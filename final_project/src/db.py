from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

# Tables

event_category_assc = db.Table("event_category_assc", db.Model.metadata, db.Column("event_id", db.Integer, db.ForeignKey("events.id")), db.Column("category_id", db.Integer, db.ForeignKey("categories.id")))
task_category_assc = db.Table("task_category_assc", db.Model.metadata, db.Column("task_id", db.Integer, db.ForeignKey("tasks.id")), db.Column("category_id", db.Integer, db.ForeignKey("categories.id")))

# Classes

class Event(db.Model):
    """
    Event Model 
    """

    __tablename__ = "events"

    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    title = db.Column(db.String, nullable = False)
    recurrence = db.Column(db.String, nullable = True)
    day_of_week = db.Column(db.String, nullable = False)
    start_time_frame = db.Column(db.String, nullable = False)
    end_time_frame = db.Column(db.String, nullable = False)
    timespan = db.relationship("Timespan", cascade = "delete")
    category = db.relationship("Category", secondary = event_category_assc, back_populates = "events")


    def __init__ (self, **kwargs):
        """
        Initialize Event object/entry
        """
        self.title = kwargs.get("title", "")
        self.recurrence = kwargs.get("recurrence", "")
        self.day_of_week = kwargs.get("day_of_week", "")
        self.start_time_frame = kwargs.get("start_time_frame", "")
        self.end_time_frame = kwargs.get("end_time_frame", "")
    

    def simple_serialize(self):
        """
        Simple serialize a Event object
        """
        return {
            "id": self.id,
            "title": self.title,
            "recurrence": self.recurrence,
            "day_of_week": self.day_of_week,
            "start_time_frame": self.start_time_frame,
            "end_time_frame": self.end_time,
            "timespan" : [t.serialize() for t in self.timespan],            
        }
    
    
    def serialize(self):
        """
        Serialize a Event object
        """
        return {
            "id": self.id,
            "title": self.title,
            "recurrence": self.recurrence,
            "day_of_week": self.day_of_week,
            "start_time_frame": self.start_time_frame,
            "end_time_frame": self.end_time_frame,
            "timespan" : [t.serialize() for t in self.timespan],            
            "category" : [c.serialize() for c in self.category]
        }


class Category(db.Model):
    """
    Category Model
    """

    __tablename__ = "categories"

    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    category = db.Column(db.String, nullable = False)
    events = db.relationship("Event", secondary = event_category_assc, back_populates = "category")
    tasks = db.relationship("Tasks", secondary = task_category_assc, back_populates = "category")


    def __inti__(self, **kwargs):
        """
        Initialize Category object/entry
        """
        self.category = kwargs.get("category", "")

    
    def serialize(self):
        """
        Serialize a Category object
        """
        return {
            "id": self.id,
            "category": self.category,
            "events": [e.simple_serialize() for e in self.events],
            "tasks": [t.simple_serialize() for t in self.events]
        }


class Timespan(db.Model):
    """
    Timespan Model
    """

    __tablename__ = "timespans"

    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    start_time = db.Column(db.String, nullable = False)
    end_time = db.Column(db.String, nullable = False)
    date = db.Column(db.String, nullable = False)
    event_id = db.Column(db.Integer, db.ForeignKey("events.id"), nullable = False)


    def __init__ (self, **kwargs):
        """
        Initialize Timespan object/entry
        """
        self.start_time = kwargs.get("start_time", "")
        self.end_time = kwargs.get("end_time", "")
        self.date = kwargs.get("date", "")
        self.event_id = kwargs.get("event_id")


    def serialize(self):
        """
        Serialize a Timespan object
        """
        return {
            "id": self.id,
            "start_time": self.start_time,
            "end_time" : self.end_time,
            "date": self.date,
            "event_id" : self.event_id
        }
    

class Journal(db.Model):
    """
    Journal Model 
    """

    __tablename__ = "journals"

    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    title = db.Column(db.String, nullable = False)
    date = db.Column(db.String, nullable = True)
    content = db.Column(db.String, nullable = False)
    mood = db.Column(db.String, nullable = False)

    def __init__ (self, **kwargs):
        """
        Initialize Journal object/entry
        """
        self.title = kwargs.get("title", "")
        self.date = kwargs.get("date", "")
        self.content = kwargs.get("content", "")
        self.mood = kwargs.get("mood", "")
    
    
    def serialize(self):
        """
        Serialize a Journal object
        """
        return {
            "id": self.id,
            "title": self.title,
            "date": self.date,
            "content": self.content, 
            "mood" : self.mood
        }


class Task(db.Model):
    """
    Task Model 
    """

    __tablename__ = "tasks"

    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    description = db.Column(db.String, nullable = False)
    date = db.Column(db.String, nullable = True)
    status = db.Column(db.Boolean, nullable = False)
    category = db.relationship("Category", secondary = task_category_assc, back_populates = "tasks")



    def __init__ (self, **kwargs):
        """
        Initialize Task object/entry
        """
        self.description = kwargs.get("description", "")
        self.date = kwargs.get("date", "")
        self.status = kwargs.get("done", False)

    def simple_serialize(self):
        """
        Serialize a task object
        """
        return {
            "id": self.id,
            "description": self.description,
            "date": self.date,
            "status": self.status, 
        }    
    
    def serialize(self):
        """
        Serialize a task object
        """
        return {
            "id": self.id,
            "description": self.description,
            "date": self.date,
            "status": self.status, 
            "category" : [c.serialize() for c in self.category]

        }
