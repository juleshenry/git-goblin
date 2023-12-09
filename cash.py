import functools
import json
import os


def cache_to_file(file_path):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            # Check if the cache file exists
            if os.path.exists(file_path):
                # If it exists, read the cached data from the file
                with open(file_path, "r") as file:
                    try:
                        cached_result = json.load(file)
                        print(f"Cache hit for {file_path}")
                        return cached_result
                    except json.JSONDecodeError:
                        pass

            # If the cache file doesn't exist or is invalid, call the original function
            result = func(*args, **kwargs)

            # Save the result to the cache file
            with open(file_path, "w") as file:
                json.dump(result, file)

            return result

        return wrapper

    return decorator


@cache_to_file
def hard(x):
    print("superhard")
    return 42


hard(4)
