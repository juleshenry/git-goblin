import functools
import json
import os


# WTF. NEED TO CACHE IN JSON WHILE USING AK AS UID... I/O IS THE ISSUE TRANSLATING...
# SHALLOW VERSION
"""
{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}
{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}
{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}
{,.'******{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{***}{,.'}{,.'}{,.'***.'}{,.'***.'}
{,.*******{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{***}{,.'}{,.'}{,.'***.'}{,.****.'}
{,********{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{***}{,.'}{,.'}{,.'***.'}{,.****.'}
{,******'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{***}{,.'}{,.'}{,.'}{,.'}{,.****.'}
{,****,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{***}{,.'}{,.'}{,.'}{,.'}{,.****.'}
{,****,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{***}{,.'}{,.'}{,.'}{,.'}{,.****.'}
*********}{,.'***.'}{,.'****'}{,.'}*********}{,.'}{***}{,.'******{,.'***.'}{*********
*********}{,.'***.'}{,.'****'}{,.'***********{,.'}{***}{,.******}{,.'***.'}{*********
*********}{,.'***.'}{,.'****'}{,.*************,.'}{***}{,******'}{,.'***.'}{*********
{,****,.'}{,.'***.'}{,.'****'}{,.*************,.'}{***}{******.'}{,.'***.'}{,.****.'}
{,****,.'}{,.'***.'}{,.'****'}{,*****.'}{,*****.'}{***}*****{,.'}{,.'***.'}{,.****.'}
{,****,.'}{,.'***.'}{,.'****'}{,****,.'}{,.****.'}{********}{,.'}{,.'***.'}{,.****.'}
{,****,.'}{,.'***.'}{,.'****'}{,****,.'}{,.'}{,.'}{********}{,.'}{,.'***.'}{,.****.'}
{,****,.'}{,.'***.'}{,.'****'}{,****,.'}{,.'}{,.'}{*********{,.'}{,.'***.'}{,.****.'}
{,****,.'}{,.'***.'}{,.'****'}{,****,.'}{,.'}{,.'}{*********{,.'}{,.'***.'}{,.****.'}
{,****,.'}{,.'***.'}{,.'****'}{,****,.'}{,.'}{,.'}{****{*****,.'}{,.'***.'}{,.****.'}
{,****,.'}{,.'***.'}{,.'****'}{,****,.'}{,.'}{,.'}{***}{,****,.'}{,.'***.'}{,.****.'}
{,****,.'}{,.'****'}{,.'****'}{,****,.'}{,.****.'}{***}{,*****.'}{,.'***.'}{,.****.'}
{,****,.'}{,.'****'}{,.*****'}{,*****.'}{,*****.'}{***}{,.*****'}{,.'***.'}{,.****.'}
{,****,.'}{,.'**************'}{,.**************.'}{***}{,.'****'}{,.'***.'}{,.*****'}
{,****,.'}{,.'**************'}{,.*************,.'}{***}{,.'*****}{,.'***.'}{,.*******
{,****,.'}{,.'}*************'}{,.'***********{,.'}{***}{,.'}*****{,.'***.'}{,.*******
{,****,.'}{,.'}{********}***'}{,.'}*********}{,.'}{***}{,.'}*****{,.'***.'}{,.'******
{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}
{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}
{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}{,.'}
"""


def cereal(*a, **k):
    a = list(filter(lambda x:type(x)==int or type(x)==str or type(x)==float, a))
    # for o in a:
    #     print(o,type(o))
    # print('asd')
    # for x in k:
    #     print(x,type(x))
    return str({"a": json.dumps(a), "k": json.dumps(k)})


def kash(file_path):
    file_path = file_path + ".kash"

    def decorator(func):
        @functools.wraps(func)
        def wrapper(*a, **k):
            cere = cereal(*a, **k)
            print(file_path, "!")
            if not os.path.exists(file_path):
                result = func(*a, **k)
                with open(file_path, "w+") as file:
                    new = {cere: result}
                    json.dump(new, file)
            else:
                print(f"{file_path} exists")
                with open(file_path, "r") as file:
                    print("reading...")
                    try:
                        cow = json.load(file)
                        milk = cow.get(cere)
                        print('MILK',milk)
                        if milk:
                            print(f"Cache hit!")
                            return milk
                        print('cc',cow)
                    except json.JSONDecodeError as e:
                        print("JSNFAL", e)
                    print("exists but failed to find it in cache")

                    result = func(*a, **k)
                    bigger = dict({cere: result}, **cow)

                    print('BESTT',)
                    with open(file_path, "w+") as file:
                        json.dump(bigger, file)

            return result

        return wrapper

    return decorator


@kash("good")
def fib(*a, **k):
    for _ in range(1000):
        pass
    print("~~~!!!!!@@@@@((((*****))))````````"*2)
    return f"F({cereal(*a,**k)})"


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
        print("~~~~~@@@@@@$$$$$(((()))))"*8)
        return f"F({cereal(*a,**k)})"


# Basic
print(f'>>{(etap:="step two")}<<', fib(1, 2, 3, "arg", key="key", kwarg=etap))

# print(f'>>{(etap:="step uno")}<<', A().fib(1, 2, 3, "arg", key="key", kwarg=etap))


# print(fib(1,2,3, "foo", key="bar", kwarg="kwarg"))
# print(fib(9,9,9, "foo", key="bar"))
