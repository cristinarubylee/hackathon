from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

# Tables

event_category_assc = db.Table("event_category_assc", db.Model.metadata, db.Column("event_id", db.Integer, db.ForeignKey("events.id")), db.Column("category_id", db.Integer, db.ForeignKey("categories.id")))

# Classes

class Event(db.Model):
    """
    Event Model 
    """

    __tablename__ = "events"

    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    title = db.Column(db.String, nullable = False)
    date = db.Column(db.String, nullable = True)
    type = db.Column(db.String, nullable = False)
    start_time = db.Column(db.String, nullable = False)
    end_time = db.Column(db.String, nullable = False)
    timespan = db.relationship("Timespan", cascade = "delete")
    category = db.relationship("Category", secondary = event_category_assc, back_populates = "events")


    def __init__ (self, **kwargs):
        """
        Initialize Event object/entry
        """
        self.title = kwargs.get("title", "")
        self.date = kwargs.get("date", "")
        self.type = kwargs.get("type", "")
        self.start_time = kwargs.get("start_time", "")
        self.end_time = kwargs.get("end_time", "")
    

    def simple_serialize(self):
        """
        Simple serialize a Event object
        """
        return {
            "id": self.id,
            "title": self.title,
            "date": self.date,
            "type": self.type,
            "start_time": self.start_time,
            "end_time": self.end_time,
            "timespan" : [t.serialize() for t in self.timespan],            
        }
    
    
    def serialize(self):
        """
        Serialize a Event object
        """
        return {
            "id": self.id,
            "title": self.title,
            "date": self.date,
            "type": self.type,
            "start_time": self.start_time,
            "end_time": self.end_time,
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
            "events": [e.simple_serialize() for e in self.events]
        }


class Timespan(db.Model):
    """
    Timespan Model
    """

    __tablename__ = "timespans"

    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    recurrence = db.Column(db.String, nullable = False)
    start_time = db.Column(db.String, nullable = False)
    end_time = db.Column(db.String, nullable = False)
    start_time_frame = db.Column(db.String, nullable = False)
    end_time_frame = db.Column(db.String, nullable = False)
    event_id = db.Column(db.Integer, db.ForeignKey("events.id"), nullable = False)


    def __init__ (self, **kwargs):
        """
        Initialize Timespan object/entry
        """
        self.recurrence = kwargs.get("recurrence", "")
        self.start_time = kwargs.get("start_time", "")
        self.end_time = kwargs.get("end_time", "")
        self.start_time_frame = kwargs.get("start_time_frame", "")
        self.end_time_frame = kwargs.get("end_time_frame", "")
        self.event_id = kwargs.get("event_id")


    def serialize(self):
        """
        Serialize a Timespan object
        """
        return {
            "id": self.id,
            "recurrence": self.recurrence,
            "start_time": self.start_time,
            "end_time" : self.end_time,
            "start_time_frame": self.start_time_frame,
            "end_time_frame": self.end_time_frame,
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
    due_date = db.Column(db.String, nullable = True)
    status = db.Column(db.Boolean, nullable = False)
    subtasks = db.relationship("Subtask", cascade = "delete")


    def __init__ (self, **kwargs):
        """
        Initialize Task object/entry
        """
        self.description = kwargs.get("description", "")
        self.due_date = kwargs.get("due_date", "")
        self.status = kwargs.get("done", False)
        
    
    def serialize(self):
        """
        Serialize a task object
        """
        return {
            "id": self.id,
            "decription": self.description,
            "due_date": self.due_date,
            "status": self.status, 
            "subtasks" : [s.serialize() for s in self.subtasks]
        }


class Subtask(db.Model):
    """
    Subtask Model
    """

    __tablename__ = "subtasks"

    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    description = db.Column(db.String, nullable = False)
    status = db.Column(db.Boolean, nullable = False)
    task_id = db.Column(db.Integer, db.ForeignKey("tasks.id"), nullable = False)


    def __init__ (self, **kwargs):
        """
        Initialize Subtask object/entry
        """
        self.description = kwargs.get("description", "")
        self.status = kwargs.get("status", False)
        self.task_id = kwargs.get("task_id")


    def serialize(self):
        """
        Serialize a subtask object
        """
        return {
            "id": self.id,
            "decription": self.description,
            "status": self.status,
            "task_id" : self.task_id
        }
    
