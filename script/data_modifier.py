import json
import sys
import os
import re

def get_sanitizer(file_path):
    with open(file_path) as file:
        lines = file.readlines()

    sanitizer = ""
    for line in lines:
        if re.findall(r'^AFL_USE_ & =1$', line):
            sanitizer = line.split('_ |=')[2]

    return sanitizer

def read_fuzzer_stats(file_path):
    
    with open(file_path, "r") as file:
        lines = file.readlines()
    
    data = {}

    for line in lines:
        key, value = line.strip().split(':')
        key = key.strip()
        value = value.strip()

        data[key] = value
    
    fuzzer_stats: dict = json.loads(json.dumps(data, indent=4))
    
    return fuzzer_stats

def json_to_file(data_json):
    file_name = "data.json"
    if os.path.exists(file_name):
        with open(file_name, "r") as file:
            try:
                data = json.load(file)
            except json.JSONDecodeError:
                data = []
        data.append(data_json)

        with open(file_name, "w") as file:
            json.dump(data, file)
    else:
        with open(file_name, "w") as file:
            data_json = [data_json]
            json.dump(data_json, file)

path = sys.argv[1]
fuzzer: str = sys.argv[2]
execution_time = sys.argv[3]
last_folder = sys.argv[4]

analisys_data: dict = read_fuzzer_stats(path + '/results/result-'+ last_folder + '/default/fuzzer_stats')
analisys_data["tool"] = fuzzer
analisys_data["sanitizer"] = get_sanitizer(path + '/results/result-'+ last_folder + '/default/fuzzer_setup')
analisys_data["time"] = execution_time

json_to_file(analisys_data)


