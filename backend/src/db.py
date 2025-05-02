from flask_sqlalchemy import SQLAlchemy
import enum

db = SQLAlchemy()

# Tables

event_category_assc = db.Table("event_category_assc", db.Model.metadata, db.Column("event_id", db.Integer, db.ForeignKey("events.id")), db.Column("category_id", db.Integer, db.ForeignKey("categories.id")))
task_category_assc = db.Table("task_category_assc", db.Model.metadata, db.Column("task_id", db.Integer, db.ForeignKey("tasks.id")), db.Column("category_id", db.Integer, db.ForeignKey("categories.id")))

# Classes

class Frequency(enum.Enum):
    DAILY = "DAILY"
    WEEKLY = "WEEKLY"
    MONTHLY = "MONTHLY"
    NONE = "NONE"  # for one-time events
    
class Event(db.Model):
    """
    Event Model 
    """

    __tablename__ = "events"

    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    title = db.Column(db.String, nullable = False)
    recurrence = db.Column(db.Enum(Frequency), default=Frequency.NONE, nullable=False)
    start_time_frame = db.Column(db.String, nullable = False)
    end_time_frame = db.Column(db.String, nullable = False)
    timespan = db.relationship("Timespan", cascade = "all, delete", back_populates="event")
    category = db.relationship("Category", secondary = event_category_assc, back_populates = "events")


    def __init__ (self, **kwargs):
        """
        Initialize Event object/entry
        """
        self.title = kwargs.get("title", "")
        self.recurrence = kwargs.get("recurrence", "")
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
            "start_time_frame": self.start_time_frame,
            "end_time_frame": self.end_time_frame,
            "timespan" : [t.serialize() for t in self.timespan],            
        }
    
    
    def serialize(self):
        """
        Serialize a Event object
        """
        return {
            "id": self.id,
            "title": self.title,
            "recurrence": self.recurrence.value,
            "start_time_frame": self.start_time_frame,
            "end_time_frame": self.end_time_frame,
            "timespan" : [t.simple_serialize() for t in self.timespan],            
            "category" : [c.simple_serialize() for c in self.category]
        }
        

class Category(db.Model):
    """
    Category Model
    """

    __tablename__ = "categories"

    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    category = db.Column(db.String, nullable = False)
    events = db.relationship("Event", secondary = event_category_assc, back_populates = "category")
    tasks = db.relationship("Task", secondary = task_category_assc, back_populates = "category")


    def __init__(self, **kwargs):
        """
        Initialize Category object/entry
        """
        self.category = kwargs.get("category", "")

    def simple_serialize(self):
        """
        Serialize a Category object
        """
        return {
            "id": self.id,
            "category": self.category
        }
    
    def serialize(self):
        """
        Serialize a Category object
        """
        return {
            "id": self.id,
            "category": self.category,
            "events": [e.simple_serialize() for e in self.events],
            "tasks": [t.simple_serialize() for t in self.tasks]
        }


class Timespan(db.Model):
    """
    Timespan Model
    """

    __tablename__ = "timespans"

    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    start_time = db.Column(db.String, nullable = False)
    end_time = db.Column(db.String, nullable = False)
    day_of_week = db.Column(db.String, nullable=False)  # e.g. "MON", "TUE"
    event_id = db.Column(db.Integer, db.ForeignKey("events.id"), nullable = False)
    event = db.relationship("Event", back_populates="timespan")

    def __init__ (self, **kwargs):
        """
        Initialize Timespan object/entry
        """
        self.start_time = kwargs.get("start_time", "")
        self.end_time = kwargs.get("end_time", "")
        self.day_of_week = kwargs.get("day_of_week", "")
        self.event_id = kwargs.get("event_id")

    def simple_serialize(self):
            """
            Serialize a Timespan object
            """
            return {
                "id": self.id,
                "start_time": self.start_time,
                "end_time" : self.end_time,
                "day_of_week": self.day_of_week,
            }

    def serialize(self):
        """
        Serialize a Timespan object
        """
        return {
            "id": self.id,
            "start_time": self.start_time,
            "end_time" : self.end_time,
            "day_of_week": self.day_of_week,
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
        self.status = kwargs.get("status", False)

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
