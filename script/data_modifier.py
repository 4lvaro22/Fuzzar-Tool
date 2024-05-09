import json
import sys
import os
import re
import uuid

def get_sanitizer(file_path):
    with open(file_path) as file:
        lines = file.readlines()

    sanitizer = ""
    for line in lines:
        if re.findall(r'AFL_USE_[A-Za-z]+=1', line):
            sanitizer = line.replace('=', '_').split('_')[2]

    return sanitizer

def findings(dir_path):
    findings = 0;
    for file in os.listdir(dir_path):
        if os.system(f'file -b {file}') == "data":
            findings += 1

    return findings

def json_to_file(data_json):
    file_name = "data.json"
    if os.path.exists(file_name):
        with open(file_name, "r") as file:
            try:
                data = json.load(file)
            except json.JSONDecodeError:
                data = []
        data.append(data_json)
        data = sorted(data, key=lambda d: d['start_time'], reverse=True)
        with open(file_name, "w") as file:
            json.dump(data, file)
    else:
        with open(file_name, "w") as file:
            data_json = [data_json]
            json.dump(data_json, file)

data_source = sys.argv[1]
path = sys.argv[2]
name = sys.argv[3]
conf_fuzzing = sys.argv[4]
description = sys.argv[5]


analisys_data: dict = {}

analisys_data["path"] = path
analisys_data["name"] = name
analisys_data["conf_fuzzing"] = conf_fuzzing
analisys_data["data_source"] = data_source
analisys_data["description"] = description
analisys_data["findings"] = findings(path)
analisys_data["id"] = str(uuid.uuid4())

json_to_file(analisys_data)


