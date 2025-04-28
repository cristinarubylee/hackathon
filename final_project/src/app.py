import json

from db import db
from flask import Flask, request
from db import Event, Category, Timespan, Journal, Task
from datetime import datetime

app = Flask(__name__)
db_filename = "cms.db"

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
    pass

@app.route("/api/events/<int:event_id>/")
def event_by_id(event_id):
    pass

@app.route("/api/events/", methods=["POST"])
def create_event():
    pass

@app.route("/api/events/<int:event_id>/", methods=["DELETE"])
def delete_event(event_id):
    pass

@app.route("/api/events/<int:event_id>/", methods=["POST"])
def update_event(event_id):
    pass

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
    return success_response ({"categories": [c.serialize() for c in Category.query.filter_by(id=cat_id)]})


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
        return failure_response("Invalid Date, Expected format = Day, Month, Year", 400)
    
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
        return failure_response("Invalid Date, Expected format = Day, Month, Year", 400)
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
        return failure_response("Invalid Date, Expected format = Day, Month, Year", 400)
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
        return failure_response("Invalid Date, Expected format = Day, Month, Year", 400)
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
