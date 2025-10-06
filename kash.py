import functools
import json
import os


def serialize_args(*a, **k):
    a = [x for x in a if isinstance(x, (int, str, float))]
    return str({"a": json.dumps(a), "k": json.dumps(k)})


def kash(cache_file):
    cache_file = cache_file + ".kash"

    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            try:
                with open(cache_file, "r") as file:
                    cache_data = json.load(file)
            except (json.JSONDecodeError, FileNotFoundError):
                cache_data = {}

            key = serialize_args(*args, **kwargs)
            cached_result = cache_data.get(key)

            if cached_result is None:
                result = func(*args, **kwargs)
                cache_data[key] = result
                with open(cache_file, "w") as file:
                    json.dump(cache_data, file)
            else:
                result = cached_result

            return result

        return wrapper

    return decorator


@kash("good")
def fib(*a, **k):
    for _ in range(1000):
        pass
    print("~~~!!!!!@@@@@((((*****))))````````" * 2)
    return f"F({serialize_args(*a,**k)})"


class A:
    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__, sort_keys=True, indent=4)

    def to_json(self):
        return json.dumps(self, default=lambda o: o.__dict__, sort_keys=True, indent=4)

    def __serialize__(self):
        # Convert the object to a dictionary that can be serialized
        return {"image_paths": self.image_paths}

    @classmethod
    def __deserialize__(cls, data):
        # Create an instance of the class using the deserialized data
        return cls(**data)

    @kash("A-class")
    def fib(*a, **k):
        for _ in range(1000):
            pass
        print("~~~~~@@@@@@$$$$$(((()))))" * 8)
        return f"F({serialize_args(*a,**k)})"


# Basic ( Run these 1 @ a time, then notice...)
"""
@kash("good")
def fib(*a, **k):
    for _ in range(1000):
        pass
    print("~~~!!!!!@@@@@((((*****))))````````" * 2)
    return f"F({serialize_args(*a,**k)})"
print(f'>>{(etap:="step one")}<<', fib(1, 2, 3, "arg", key="key", kwarg=etap))
print(f'>>{(etap:="step one")}<<', fib(1, 2, 3, "arg", key="key", kwarg=etap))
print(f'>>{(etap:="step two")}<<', fib(1, 2, 3, "arg", key="key", kwarg=etap))
print(f'>>{(etap:="step two")}<<', fib(1, 2, 3, "arg", key="key", kwarg=etap))
print(f'>>{(etap:="step one")}<<', fib(1, 2, 3, "arg", key="key", kwarg=etap))
"""
if __name__ == "__main__":

    @kash("good")
    def fib(*a, **k):
        for _ in range(1000):
            pass
        print("~~~!!!!!@@@@@((((*****))))````````" * 2)
        return f"F({serialize_args(*a,**k)})"

    print(f'>>{(etap:="step one")}<<', fib(1, 2, 3, "arg", key="key", kwarg=etap))
    print(f'>>{(etap:="step one")}<<', fib(1, 2, 3, "arg", key="key", kwarg=etap))
    print(f'>>{(etap:="step two")}<<', fib(1, 2, 3, "arg", key="key", kwarg=etap))
    print(f'>>{(etap:="step two")}<<', fib(1, 2, 3, "arg", key="key", kwarg=etap))
    print(f'>>{(etap:="step one")}<<', fib(1, 2, 3, "arg", key="key", kwarg=etap))
    print("expected")
    print(
        """
~~~!!!!!@@@@@((((*****))))````````~~~!!!!!@@@@@((((*****))))````````
>>step one<< F({'a': '[1, 2, 3, "arg"]', 'k': '{"key": "key", "kwarg": "step one"}'})
>>step one<< F({'a': '[1, 2, 3, "arg"]', 'k': '{"key": "key", "kwarg": "step one"}'})
~~~!!!!!@@@@@((((*****))))````````~~~!!!!!@@@@@((((*****))))````````
>>step two<< F({'a': '[1, 2, 3, "arg"]', 'k': '{"key": "key", "kwarg": "step two"}'})
>>step two<< F({'a': '[1, 2, 3, "arg"]', 'k': '{"key": "key", "kwarg": "step two"}'})
>>step one<< F({'a': '[1, 2, 3, "arg"]', 'k': '{"key": "key", "kwarg": "step one"}'})
"""
    )
