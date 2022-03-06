from flask import Flask
from flask import jsonify

from google.cloud import vision
from google.oauth2 import service_account
import io

import datetime
import os

json_data['private_key'] = json_data['private_key'].replace('\\n', '\n')

credentials = service_account.Credentials.from_service_account_info(json_data)
client = vision.ImageAnnotatorClient(credentials=credentials)


app = Flask(__name__)

def get_item(s):
    words = s.split(' ')
    if not words[-1].startswith('*'):
        return None
    fiyat = words[-1][1:].replace(',', '.')
    try:
        fiyat = float(fiyat)
    except:
        return None
    return (' '.join(words[:-1]), fiyat)

def detect_text(path):
    """Detects text in the file."""
    if path.startswith('http'):
        image = vision.Image()
        image.source.image_uri = path
    else:

        with io.open(path, 'rb') as image_file:
            content = image_file.read()

        image = vision.Image(content=content)



    response = client.text_detection(image=image)
    # print(help(client.text_detection))

    # texts = response.text_annotations
    # print(texts[0].description)
    # print('Texts:')

    items = []
    lines = {}

    for text in response.text_annotations[1:]:
        top_x_axis = text.bounding_poly.vertices[0].x
        top_y_axis = text.bounding_poly.vertices[0].y
        bottom_y_axis = text.bounding_poly.vertices[3].y

        if top_y_axis not in lines:
            lines[top_y_axis] = [(top_y_axis, bottom_y_axis), []]

        for s_top_y_axis, s_item in lines.items():
            if top_y_axis < s_item[0][1]:
                lines[s_top_y_axis][1].append((top_x_axis, text.description))
                break

    for _, item in lines.items():
        if item[1]:
            words = sorted(item[1], key=lambda t: t[0])
            items.append((item[0], ' '.join([word for _, word in words]), words))

    # print(items)
    res = []
    for item in items:
        s = item[1]
        cur_item = get_item(s)
        if cur_item != None:
            res.append(cur_item)
    return res

EXCLUDING_KEYWORDS = ['toplam', 'topkdv', 'garanti', 'kredi', 'karti']

import random

FOOD_KEYWORDS = ['yumurta', 'jelibon', 'karadem', 'makarna', 'un', 'süt', 'birşah']

def get_category_item(item):
    s = item[0].lower()
    if any(keyword in s for keyword in EXCLUDING_KEYWORDS):
        return None
    if any(keyword in s for keyword in FOOD_KEYWORDS):
        return 'Food'
    list = ["Food", "Cleaning", "Bakery", "Cosmetic", "Glassware", "Textile"]
    return random.choice(list)

Dict={"Food": 26.258920, "Cleaning":98.50913, "Textile": 15.30498, "Bakery":20.41960,"Cosmetic": 43.51043,"Glassware": 11.75545}
newDict={}
for i in Dict.items():
    newDict[i[0]]=((i[1]/14.19)/7)


def get_carbon_coef(category):
    return newDict[category]

@app.route('/test/<path:path>')
def test(path):
    return path

@app.route('/test2/<path:path>')
def test2(path):
    items = detect_text(path)
    return jsonify(items)

@app.route('/get_carbon_footprint/<path:path>')
def get_carbon_footprint(path):
    """Return the carbon footprint by category of the user as json"""
    print(path)
    items = detect_text(path)
    print(items)
    d = {}
    res = []
    for item in items:
        category = get_category_item(item[0])
        if category == None:
            continue
        carbon_coef = get_carbon_coef(category)
        if category not in d:
            d[category] = carbon_coef * item[1]
        else:
            d[category] += carbon_coef * item[1]
    res = []
    for category, emission in d.items():
        res.append({'category': category, 'date':datetime.date.today().strftime("%d/%m/%Y"), 'emission': emission})
    return jsonify(res)

@app.route("/")
def index():
    return "Hello World!"

# make flask run
if __name__ == "__main__":
    # print(get_carbon_footprint('https://cdn.odatv4.com/images2/2020_10/2020_10_08/screenshot_7.jpg'))
    app.run(debug=True)