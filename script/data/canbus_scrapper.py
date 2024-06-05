import subprocess
import time
import os

def run_cangen():
    return subprocess.Popen(['cangen', 'vcan0'])

def run_candump(file_path):
    with open(file_path, 'w') as f:
        return subprocess.Popen(['candump', 'vcan0', '-L'], stdout=f)
    
def main(duration, file_path):
    cangen_proc = run_cangen()
    candump_proc = run_candump(file_path)

    time.sleep(duration)

    cangen_proc.terminate()
    candump_proc.terminate()

    cangen_proc.wait()
    candump_proc.wait()

if __name__ == "__main__":
    _path_inputs = os.getcwd() + "/inputs"
        
    if not os.path.exists(_path_inputs):
        os.mkdir(_path_inputs)

    duration = 10
    file_path = 'inputs/candump_output.txt'
    main(duration, file_path)

    lines = []

    with open("inputs/candump_output.txt", "r") as read_file:
        lines = read_file.readlines()
        read_file.close()

    if lines != []:
        for i, data in enumerate(lines):
            with open("./inputs/data_" + str(i) + ".txt", "w") as write_file:
                write_file.write(data.split(' ')[-1])


