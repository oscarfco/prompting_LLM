import requests
import time
import argparse

def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--connection_str", type=str, default="http://127.0.0.1:5000")

    args = parser.parse_args()
    return args

def main():
    args = get_args()
    # Wait for the model to load
    print("Waiting for model to load")
    tries = 0
    while True:
        try:
            requests.post(f"{args.connection_str}/params").json()
            break
        except:
            time.sleep(5)
            tries += 1
            if tries % 50 == 0:
                print(f"Failed on {tries} tries.")
            if tries > 50:
                raise RuntimeError("Model failed to load")

if __name__ == "__main__":
    main()
