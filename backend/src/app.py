import json

from db import db
from flask import Flask, request
from db import Event, Category, Timespan, Journal, Task, Frequency
from datetime import datetime

app = Flask(__name__)
db_filename = "calendar.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():
    db.create_all()

######################################################################
# Helper Functions
######################################################################

def success_response(data, code=200):
    return json.dumps(data), code


def failure_response(message, code=404):
    return json.dumps({"error": message}), code

def is_valid_date(date_string):
    if date_string == None:
        return False
    else:
        try:
            datetime.strptime(date_string, "%Y-%m-%d")
            return True
        except ValueError:
            return False
        
######################################################################
# Routes 
######################################################################

@app.route("/")
def base_route():
    pass

########################################
# Events Endpoints
########################################

@app.route("/api/events/date/")
def event_by_date():
    """
    Endpoint to get all events, using date
    """
    body = json.loads(request.data)
    if 'date' not in body:
        return failure_response("Missing date field!", 400)
    date_input = body.get("date")
    if not is_valid_date(date_input):
        return failure_response("Invalid Date, Expected format = YYYY-MM-DD", 400)
    
    # Parse date and determine its weekday abbreviation (e.g., "MON", "TUE", ...)
    query_date = datetime.strptime(date_input, "%Y-%m-%d").date()
    day_of_week = query_date.strftime("%a").upper()
    day_of_month = query_date.day

    all_events = (
        Event.query.join(Timespan).filter(
            Event.start_time_frame <= query_date,
            Event.end_time_frame >= query_date,
        ).all()
    )

    filtered_events = []
    for event in all_events:
        recurrence = event.recurrence
        if recurrence == Frequency.DAILY:
            filtered_events.append(event)
        elif recurrence == Frequency.WEEKLY and any(t.day_of_week == day_of_week for t in event.timespan):
            filtered_events.append(event)
        elif recurrence == Frequency.MONTHLY and any(int(t.day_of_week) == day_of_month for t in event.timespan if t.day_of_week.isdigit()):
            filtered_events.append(event)
        elif recurrence == Frequency.NONE:
            filtered_events.append(event) # Just add event, assuming that the time_frames are the same so event happens only one day

    unique_events = {event.id: event.serialize() for event in filtered_events} # Dictionary to ensure only unique events
    return success_response({"events": list(unique_events.values())})

@app.route("/api/events/<int:event_id>/")
def event_by_id(event_id):
    """
    Endpoint to get event information, using event_id
    """
    event = Event.query.filter_by(id=event_id).first()
    if event is None:
        return failure_response("Event not found!")
    return success_response (event.serialize())

@app.route("/api/events/", methods=["POST"])
def create_event():
    """
    Endpoint to create event
    """
    body = json.loads(request.data)
    required_fields = ["title", "recurrence", "start_time_frame", "end_time_frame", "timespan"]
    for field in required_fields:
        if field not in body:
            return failure_response(f"Missing required field: {field}", 400)
    
    title = body.get("title", "") # Defaults to empty string for title if field is empty
    recurrence = body.get("recurrence")
    start_str = body.get("start_time_frame")
    end_str = body.get("end_time_frame")
    timespan = body.get("timespan")
    category_ids = body.get("category", [])

    try:
        # Try to convert the string value to an enum
        Frequency(recurrence)
    except ValueError:
        valid_values = [freq.value for freq in Frequency]
        return failure_response(f"Invalid recurrence value. Must be one of: {valid_values}", 400)
    
    if not start_str or not end_str:
        return failure_response("start_time_frame and end_time_frame be non-empty strings", 400)
    
    if not timespan:
        return failure_response("timespan must be a non-empty list", 401)
    
    try:
        start_date = datetime.strptime(start_str, "%Y-%m-%d").date()
        end_date = datetime.strptime(end_str, "%Y-%m-%d").date()
    except ValueError:
        return failure_response("Invalid date format. Use YYYY-MM-DD.", 400)
    
    if start_date > end_date:
        return failure_response("start_time_frame must be before end_time_frame.", 400)
     
    new_event = Event(
        title=title,
        recurrence=recurrence,
        start_time_frame=start_date,
        end_time_frame=end_date,
    )

    valid_days = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
    for ts in timespan:
        if not all(k in ts for k in ("day_of_week", "start_time", "end_time")):
            return failure_response("Each timespan must include 'day_of_week', 'start_time', and 'end_time'", 400)
        
        day = ts["day_of_week"].upper()
        if day not in valid_days:
            return failure_response(f"Invalid day_of_week: {ts['day_of_week']}. Must be a valid day name.", 400)
            
        # Validate time format
        try:
            datetime.strptime(ts["start_time"], "%H:%M")
            datetime.strptime(ts["end_time"], "%H:%M")
        except ValueError:
            return failure_response("Invalid time format. Use HH:MM for start_time and end_time.", 400)
            
        # Validate that start_time is before end_time
        if ts["start_time"] >= ts["end_time"]:
            return failure_response("start_time must be before end_time for each timespan", 400)
        
    db.session.add(new_event)
    db.session.flush()  # Ensures new_event.id is available before adding Timespans

    # Add Timespans
    for ts in timespan:
        new_timespan = Timespan(
            day_of_week=ts["day_of_week"].upper(),
            start_time=ts["start_time"],
            end_time=ts["end_time"],
            event_id=new_event.id
        )
        db.session.add(new_timespan)

    # Add Categories if provided
    if category_ids:
        categories = Category.query.filter(Category.id.in_(category_ids)).all()
        new_event.category = categories

    if new_event is None:
        return failure_response("Something went wrong while creating event!", 400)

    db.session.commit()
    return success_response(new_event.serialize(), 201)

@app.route("/api/events/<int:event_id>/", methods=["DELETE"])
def delete_event(event_id):
    """
    Endpoint to delete an event by id
    """
    event = Event.query.filter_by(id=event_id).first()
    if event is None:
        return failure_response("Event not found!")
    
    db.session.delete(event)
    db.session.commit()
    return success_response(event.serialize())

@app.route("/api/events/<int:event_id>/", methods=["PUT"])
def update_event(event_id):
    """
    Endpoint to update an existing event
    """
    event = Event.query.filter_by(id=event_id).first()
    if event is None:
        return failure_response("Event not found!")

    body = json.loads(request.data)
    event.title = body.get("title", event.title)

    recurrence = body.get("recurrence")
    if recurrence:
        try:
            # Try to convert the string value to an enum
            Frequency(recurrence)
            event.recurrence = recurrence
        except ValueError:
            valid_values = [freq.value for freq in Frequency]
            return failure_response(f"Invalid recurrence value. Must be one of: {valid_values}", 400)
    
    date_updated = False

    start_str = body.get("start_time_frame")
    if start_str:
        if is_valid_date(start_str):
            event.start_time_frame = datetime.strptime(start_str, "%Y-%m-%d").date()
            date_updated = True

    end_str = body.get("end_time_frame")
    if end_str:
        if is_valid_date(end_str):
            event.end_time_frame = datetime.strptime(end_str, "%Y-%m-%d").date()
            date_updated = True

    if date_updated and event.end_time_frame < event.start_time_frame:
        return failure_response("start_time_frame must be before end_time_frame.", 400)
    
    # Update Timespans if provided
    timespan = body.get("timespan")
        
    if timespan:
        valid_days = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
        for ts in timespan:
            if not all(k in ts for k in ("day_of_week", "start_time", "end_time")):
                return failure_response("Each timespan must include 'day_of_week', 'start_time', and 'end_time'", 400)
            
            day = ts["day_of_week"].upper()
            if day not in valid_days:
                return failure_response(f"Invalid day_of_week: {ts['day_of_week']}. Must be a valid day name.", 400)
                
            try:
                datetime.strptime(ts["start_time"], "%H:%M")
                datetime.strptime(ts["end_time"], "%H:%M")
            except ValueError:
                return failure_response("Invalid time format. Use HH:MM for start_time and end_time.", 400)
                
            if ts["start_time"] >= ts["end_time"]:
                return failure_response("start_time must be before end_time for each timespan", 400)
        
        # Clear existing Timespans
        for ts in event.timespan:
            db.session.delete(ts)
        
        # Add new Timespans
        for ts in timespan:
            new_timespan = Timespan(
                day_of_week=ts["day_of_week"].upper(),
                start_time=ts["start_time"],
                end_time=ts["end_time"],
                event_id=event.id
            )
            db.session.add(new_timespan)
            
    # Update Categories if provided
    category_ids = body.get("category", [])
    if category_ids:
        categories = Category.query.filter(Category.id.in_(category_ids)).all()
        event.category = categories

    db.session.commit()
    return success_response(event.serialize(), 201)

########################################
# Task Endpoints 
########################################

@app.route("/api/task/date/")
def get_task_by_date():
    pass

@app.route("/api/task/<int:task_id>/")
def get_task_by_id(task_id):
    pass

@app.route("/api/task/", methods=["POST"])
def create_task():
    pass

@app.route("/api/task/<int:task_id>/", methods=["DELETE"])
def delete_task_id(task_id):
    pass

@app.route("/api/task/<int:task_id>/", methods=["PUT"])
def update_task_id(task_id):
    pass

########################################
# Category Endpoints
########################################

@app.route("/api/categories/")
def get_all_cats_name():
    """
    Endpoint to get all category names
    """
    return success_response ({"categories": [c.serialize()["category"] for c in Category.query.all()]})


@app.route("/api/categories/<int:cat_id>/")
def get_cat(cat_id):
    """
    Endpoint to get category information, using cat_id
    """
    return success_response ({c.serialize() for c in Category.query.filter_by(id=cat_id).first()})


@app.route("/api/categories/", methods=["POST"])
def create_cat():
    """
    Endpoint to create a category
    """
    body = json.loads(request.data)
    category_input = body.get("category")
    if (category_input == None):
        return failure_response("Missing Required Inputs: category", 400)
    new_category = Category(category = category_input)
    db.session.add(new_category)
    db.session.commit()
    return success_response(new_category.serialize(), 201)


@app.route("/api/categories/<int:cat_id>/", methods=["DELETE"])
def delete_cat(cat_id):
    """
    Endpoint to delete a specific category, using cat_id
    """
    category = Category.query.filter_by(id=cat_id).first()
    if category is None:
        return failure_response("Category Not Found")
    db.session.delete(category)
    db.session.commit()
    return success_response(category.serialize())


@app.route("/api/categories/<int:cat_id>/", methods=["PUT"])
def update_cat(cat_id):
    """
    Endpoint for updating a category, using cat_id
    """
    category = Category.query.filter_by(id=cat_id).first()
    if category is None:
        return failure_response("Category not found")
    
    body = json.loads(request.data)
    category.category = body.get("category", category.title)
    db.session.commit()
    return success_response(category.serialize())


@app.route("/api/categories/<int:cat_id>/events/<int:event_id>/", methods=["POST"])
def add_event(cat_id, event_id):
    """
    Endpoint to add an event to a category
    """
    category = Category.query.filter_by(id=cat_id).first()
    if category is None:
        return failure_response("Category not found")
    event = Event.query.filter_by(id=event_id).first()
    if event is None:
        return failure_response("Event Not Found")
    category.events.append(event)
    db.session.commit()
    return success_response(category.serialize())  


@app.route("/api/categories/<int:cat_id>/events/<int:event_id>/", methods=["DELETE"])
def remove_event(cat_id, event_id):
    """
    Endpoint for removing an event from a category
    """
    category = Category.query.filter_by(id=cat_id).first()
    if category is None:
        return failure_response("Category not found")
    event = Event.query.filter_by(id=event_id).first()
    if event is None:
        return failure_response("Event Not Found")
    if event not in category.events:
        return failure_response("Event has not been added to this category")
    category.events.remove(event)
    return success_response(event.serialize())  


@app.route("/api/categories/<int:cat_id>/tasks/<int:task_id>/", methods=["POST"])
def add_task(cat_id, task_id):
    """
    Endpoint to add a task to a category
    """
    category = Category.query.filter_by(id=cat_id).first()
    if category is None:
        return failure_response("Category not found")
    task = Task.query.filter_by(id=task_id).first()
    if task is None:
        return failure_response("Event Not Found")
    category.events.append(task)
    db.session.commit()
    return success_response(category.serialize()) 


@app.route("/api/categories/<int:cat_id>/tasks/<int:task_id>/", methods=["DELETE"])
def remove_task(cat_id, task_id):
    """
    Endpoint for removing a task from a category
    """
    category = Category.query.filter_by(id=cat_id).first()
    if category is None:
        return failure_response("Category not found")
    task = Task.query.filter_by(id=task_id).first()
    if task is None:
        return failure_response("Task Not Found")
    if task not in category.events:
        return failure_response("Task has not been added to this category")
    category.events.remove(task)
    return success_response(task.serialize())  

########################################
# Journal Endpoints
########################################

@app.route("/api/journals/", methods=["POST"])
def create_jrnal():
    """
    Endpoint to create a journal
    """
    body = json.loads(request.data)
    title_input = body.get("title")
    date_input = body.get("date")
    content_input = body.get("content", "")
    mood_input = body.get("mood", "")

    if title_input == None:
        return failure_response("Missing Required Input: Title or Date")
    if not is_valid_date(date_input):
        return failure_response("Invalid Date, Expected format = YYYY-MM-DD", 400)
    
    new_jrnal = Journal(title = title_input, date = date_input, content = content_input, mood = mood_input)
    db.session.add(new_jrnal)
    db.session.commit()
    return success_response(new_jrnal.serialize(), 201)
  

@app.route("/api/journals/date/")
def get_jrnal():
    """
    Endpoint to get a journal, using date
    """
    body = json.loads(request.data)
    date_input = body.get("date")
    if not is_valid_date(date_input):
        return failure_response("Invalid Date, Expected format = YYYY-MM-DD", 400)
    jrnal = Journal.query.filter_by(date=date_input).first()
    if jrnal is None:
        return failure_response("Journal Not Found")
    return success_response(jrnal.serialize())


@app.route("/api/journals/date/", methods=["DELETE"])
def delete_jrnal():
    """
    Endpoint to delete a specific journal, using date
    """
    body = json.loads(request.data)
    date_input = body.get("date")

    if not is_valid_date(date_input):
        return failure_response("Invalid Date, Expected format = YYYY-MM-DD", 400)
    jrnal = Journal.query.filter_by(date=date_input).first()
    if jrnal is None:
        return failure_response("Journal Not Found")
    
    db.session.delete(jrnal)
    db.session.commit()
    return success_response(jrnal.serialize())


@app.route("/api/journals/date/", methods=["PUT"])
def update_jrnal():
    """
    Endpoint for updating a journal, using date
    """
    body = json.loads(request.data)
    date_input = body.get("date")

    if not is_valid_date(date_input):
        return failure_response("Invalid Date, Expected format = YYYY-MM-DD", 400)
    jrnal = Journal.query.filter_by(date=date_input).first()
    if jrnal is None:
        return failure_response("Journal Not Found")
    
    jrnal.title = body.get("title", jrnal.title)
    jrnal.content = body.get("content", jrnal.content)
    jrnal.mood = body.get("mood", jrnal.mood)

    db.session.commit()
    return success_response(jrnal.serialize())


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
