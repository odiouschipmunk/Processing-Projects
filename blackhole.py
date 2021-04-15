import turtle
world = turtle.Turtle()

#world.speed(1)

for i in range(301):
    world.forward(180)
    world.left(70)
    world.forward(60)
    world.right(40)

    world.penup()
    world.setposition(0, 0)
    world.pendown()

    world.right(1)

turtle.done()

