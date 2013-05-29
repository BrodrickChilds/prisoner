from datetime import date

def calculate_age(born):
    yearborn = int(born[:4])
    today = date.today()
    return today.year - yearborn

