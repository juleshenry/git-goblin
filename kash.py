import functools
import json
import os


# WTF. NEED TO CACHE IN JSON WHILE USING AK AS UID... I/O IS THE ISSUE TRANSLATING...

def cereal(*a,**k):
    return str({"a":json.dumps(a),"k":json.dumps(k),""})
def kash(file_path):
    file_path = "kash_"+file_path
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*a, **k):
            # if cash
            if os.path.exists(file_path):
                with open(file_path, 'r') as file:
                    try:
                        cached_result = json.load(file)
                        if cereal(*a,**k) in cached_result["args_kwargs"]:
                            print(f"Cache hit for {file_path} is {cached_result}")
                            return cached_result
                    except json.JSONDecodeError:
                        pass
            result = func(*a, **k)
            with open(file_path, 'w') as file:
                json.dump({"result":,"arg_kwargs":[cereal(*a,**k)]+([]if not prev else prev)}, file)

            return result

        return wrapper

    return decorator

@kash("fuckit")
def fib(*a,**k):
    for _ in range(1000):pass
    print('hard funccc')
    # cerealize
    # c='_'.join(sorted(*a))+'_'+'_'.join(sorted(**k.items()))
    return {k['key']:str(sum(a[:2]))+f"_{a[3]}_"}

print(fib(1,2,3, "arg", key="key", kwarg="s"))
# print(fib(1,2,3, "foo", key="bar", kwarg="kwarg"))
# print(fib(9,9,9, "foo", key="bar"))
