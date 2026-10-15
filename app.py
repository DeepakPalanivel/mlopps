import os
import pickle
from flask import Flask, render_template, request

app = Flask(__name__)
MODEL_VERSION = "1.0"

with open("model.pkl", "rb") as f:
    model = pickle.load(f)

@app.route("/", methods=["GET", "POST"])
def home():
    prediction = None
    error = None
    if request.method == "POST":
        try:
            study_hours = float(request.form["study_hours"])
            attendance = float(request.form["attendance"])
            internal_marks = float(request.form["internal_marks"])
        except (ValueError, KeyError):
            return "Please enter valid numeric values.", 400

        if not 0 <= study_hours <= 24:
            return "Study hours must be between 0 and 24.", 400
        if not 0 <= attendance <= 100:
            return "Attendance must be between 0 and 100.", 400
        if not 0 <= internal_marks <= 50:
            return "Internal marks must be between 0 and 50.", 400

        result = model.predict([[study_hours, attendance, internal_marks]])[0]
        prediction = "Pass" if result == 1 else "Fail"

    return render_template("index.html", prediction=prediction,
                           version=MODEL_VERSION)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
