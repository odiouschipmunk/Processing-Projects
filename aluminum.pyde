def setup():
    size(600, 600)
    
def draw():
    for i in range(0, 1000):
        if i%2 == 0:
            stroke(0)
        else:
            stroke(255)
        ellipse(i, 300, 10, i*1.2)
