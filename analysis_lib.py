import sqlite3
from os import system
from tqdm import tqdm_notebook as tqdm
import seaborn as sns
import numpy as np
from matplotlib import pyplot as plt
import matplotlib.patheffects as peff
from matplotlib.collections import LineCollection
import numpy as np
from math import sqrt


conn = sqlite3.connect("resources/data.db")
cur = conn.cursor()


class Day:
    def __init__(self, vec, source, name, num, week, date):
        self.vec = vec
        self.source = source
        self.name = name
        self.num = num
        self.week = week
        self.date = date

    def __repr__(self):
        return f'{self.name}'

    __str__ = __repr__

daylist = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']

def daynum(s):
    return daylist[s]

points = []


def process_table(table, col, cat, year):
    query = f"""
            SELECT STRFTIME('%w %W', {col}),
                   STRFTIME('%m %d %Y', {col}),
                   STRFTIME('%H', {col})
            FROM {table}
            WHERE STRFTIME('%Y', {col}) = '{year}'
            """
    cur.execute(query)
    days = {}
    result = list(cur.fetchall())
    for [day, date, hour] in tqdm(result):
        if day not in days:
            days[day] = {}
        if hour not in days[day]:
            days[day][hour] = (1, date)
        else:
            days[day][hour] = (days[day][hour][0] + 1, date)

    for i in days:
        [num, week] = [int(j) for j in i.split(" ")]
        data = {int(k): v for k, (v, d) in days[i].items()}
        date = [d for k, (v, d) in days[i].items()][0]
        data = [data[j] if j in data else 0 for j in range(24)]
        points.append(Day(np.array(data), cat, f'{daynum(num)} #{week}', num, week, date))

def process_subways_table(table, col, cat, year):
    query = f"""
            SELECT STRFTIME('%w %W', {col}),
                   STRFTIME('%m %d %Y', {col}),
                   STRFTIME('%H', {col}),
                   entries,
                   exits
            FROM {table}
            WHERE STRFTIME('%Y', {col}) = '{year}'
            """
    cur.execute(query)
    days = {}
    result = list(cur.fetchall())
    for [day, date, hour, entries, exits] in tqdm(result):
        traffic = entries + exits
        if day not in days:
            days[day] = {}
        if hour not in days[day]:
            days[day][hour] = (traffic, date)
        else:
            days[day][hour] = (days[day][hour][0] + traffic, date)

    for i in days:
        [num, week] = [int(j) for j in i.split(" ")]
        data = {int(k): v for k, (v, d) in days[i].items()}
        date = [d for k, (v, d) in days[i].items()][0]
        data = [data[j] if j in data else 0 for j in range(24)]
        points.append(Day(np.array(data), cat, f'{daynum(num)} #{week}', num, week, date))


def query_day(table, col, year, day, week):
    query = f"""
            SELECT STRFTIME('%H',{col}), COUNT(*)
            FROM (
                SELECT * FROM {table}
                WHERE STRFTIME('%Y %w %W',{col})='{year} {day} {week:02}'
            )
            GROUP BY STRFTIME('%H', {col})
            """
    cur.execute(query)
    data = dict((int(i), j) for [i, j] in cur.fetchall())
    data = [data[i] if i in data else 0 for i in range(24)]
    return data



def norm(v):
    s = np.sum(v)
    return v / s if s > 0 else norm(np.ones(v.shape, np.float64))


def hellinger(x, y):
    nx = norm(x)
    ny = norm(y)
    return sqrt(max((0, 1 - np.sum(sqrt(i * j) for i, j in zip(nx, ny)))))


points = []

process_table("accidents", "time", 0, 2015)
process_subways_table("subways", "time", 1, 2016)

def squash(vec):
    new = np.zeros(vec.shape)
    for i, v in enumerate(vec):
        for j in range(i - 2, i + 2):
            if j >= 0 and j < len(new):
                new[j] += v / 5
    return new


for day in points:
    if day.source == 1:
        day.vec = squash(day.vec)
process_table("call311", "made", 2, 2014)
process_table("taxis", "pickup_datetime", 3, 2014)

cached = points
