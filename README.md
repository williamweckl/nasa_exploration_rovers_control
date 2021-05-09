# NASA Exploration Rovers Control

System designed to control exploration rovers.

## Motivation

A set of exploration rovers has been sent by NASA to Mars and will land on a ground. This ground, must be explored by the rovers so that its built-in cameras can have a complete view of the area and send the images back to Earth.

## How exploration rovers work

The position and direction of the exploration rover are represented by a combination of x-y coordinates and a letter representing the cardinal direction in which the rover points, following the `Wind Rose Compass`.

![Wind Rose Compass](https://github.com/williamweckl/nasa_exploration_rovers_control/raw/master/priv/readme_images/wind_rose_compass.jpg)

The highground is divided into a grid to simplify navigation. An example of a position would be (0, 0, N), which indicates that the rover is in the lower left corner and pointing north.

To control the rovers, NASA sends a simple sequence of letters. The letters are **"L"** (rotate the rover 90 degrees to Left), **"R"** (rotate the rover 90 degrees to Right) and **"M"** (Move the rover keeping it's direction).

In the grid, the point north of (x, y) is always (x, y + 1) and the point east of (x, y) is always (x + 1, y). I think you got the logic.

If you didn't understand for the first time do not feel dumd, I had to read it a few times and to draw it to understand. :joy:

![Ground grid](https://raw.githubusercontent.com/williamweckl/nasa_exploration_rovers_control/master/priv/readme_images/ground_grid.png)

## How the system work

NASA engineers creates a file with all the exploration rovers instructions. This file is read by the system and is sent to exploration rovers.

This files also has to include at the first line the ground size. This is important to the system be able to predict if any rover will be off the ground after the commands are executed. If that's the case, the commands will not be sent to the specific rover and a friendly error will be outputed instead of the new rover coordinates.

It seems a little complex, but don't worry if you make some mistakes when writing this file, the system can handle most of them. But you will have a chance to review the instructions before confirming the submission.

This confirmation is important because the commands after being sent take about 8 minutes to reach the rovers if you are exploring Mars.

### The commands input file

The first line is the ground size, the following lines are the exploration rover initial position and followed by another line with the commands that will be performed.

Example:

```
3 8
0 0 N
MMM
3 8 N
LMMM
```

Explaining the example:

```
3 8 (ground size)
0 0 N (Rover 1 initial position and direction)
MMM (Rover 1 commands to be performed)
3 8 N (Rover 2 initial position and direction)
LMMM (Rover 2 commands to be performed)
... (And so on, you can add many rovers as you want, the system can take care of it)
```

### The output

The output has in each line the new rover predicted position and direction (remember that it takes some time to the rovers to receive the commads, and the output will not wait for it).

Example:

```
0 3 N
0 8 W
```

Explaining the example:

```
0 3 N (Rover 1 new predicted position and direction)
0 8 W (Rover 2 new predicted position and direction)
... (And so on)
```

### The interface to interact

To interact with the system, for now we have a terminal interface but other ways can be added latter (see the architecture decisions section). You can run using your favorite linux terminal. Maybe it works on Windows and Mac too, but has not been tested.

![Terminal Interface 1](https://raw.githubusercontent.com/williamweckl/nasa_exploration_rovers_control/master/priv/readme_images/terminal_interface_1.png)

![Terminal Interface 2](https://raw.githubusercontent.com/williamweckl/nasa_exploration_rovers_control/master/priv/readme_images/terminal_interface_2.png)

![Terminal Interface 3](https://raw.githubusercontent.com/williamweckl/nasa_exploration_rovers_control/master/priv/readme_images/terminal_interface_3.png)

![Terminal Interface 4](https://raw.githubusercontent.com/williamweckl/nasa_exploration_rovers_control/master/priv/readme_images/terminal_interface_4.png)

![Terminal Interface 5](https://raw.githubusercontent.com/williamweckl/nasa_exploration_rovers_control/master/priv/readme_images/terminal_interface_5.png)

## Architecture decisions

Most of the architecture decisions was followed by conventions from Clean Architecture.

Clean architecture helps to isolate the business logic from the rest and let us developer to focus on what really matters, the business.

There is a clear separation between these two points of view in the project folder:

- `lib/nasa_exploration_rovers_control` is for the business logic
- `lib/nasa_exploration_rovers_control_terminal_interface` is for the terminal interface, our delivery mechanism. Is the way our users will interact with the business logic

At the business logic part, the file `lib/nasa_exploration_rovers_control.ex` is responsible to expose all the system use cases according to the business view for the product. This layer is known as our bounded context. It defined the boundaries, this should be the only file called by the delivery mechanisms.

At `lib/nasa_exploration_rovers_control/interactors` we can find all the use cases and it's rules.

`lib/exploration_rover` is our entity, that represents a real Exploration Rover from the real world.

Another structure that was made, following another patterns, was the folder `lib/nasa_exploration_rovers_control/celestial_bodies` that contains all the specific celestial bodies business rules, like the rule that validates that the `Mars` ground is rectangular.

There is also another folder that worth to mention that is `lib/mix/tasks`. This folder just followed the Elixir conventions to create an automated task to start some things. We are using for now just to start our terminal interface.

## Use cases

- Explore Celestial Body Using Commands From File
- Interpret Exploration Commands Input File
- Execute Exploration Rover Commands
- Rotate Exploration Rover
- Move Exploration Rover

You can see all of them with their docs and some examples in the file `lib/nasa_exploration_rovers_control.ex`.

### Entities

#### Exploration Rover

Exploration Rover entity, it represents a real exploration rover that is exploring another planet or satellite.

It has three attributes:
- position (required): A tuble with x and y axis.
- direction (required): A direction according to the Wind Rose Compass represented by a single character string. Valid values are N, S, W, E.
- commands: A list of commands to be performed by rover. Valid values for each command in the list are L (left), R (right) or M (move).

It also has a bunch of validations to prevent invalid values to be placed in these attributes.

## Some other ~~crazy~~ decisions

- A structure of **celestial bodies** was created to keep some specific logics. For now there's just `Mars`, but other celestial bodies can be easily added in the future. After all, after conquering Mars, we won't want to stop here, will we?
- `Mars` also has a specific characteristic of having its grounds to be explored as being rectangular highlands, so a specific Mars validation has been added to not allow square grounds.
- Some fake modules was created to be able to mock some Elixir and Erlang modules like `System` and `:timer`. The decision of which module will be used is made by the environment (see `config` folder files). The default is to use the language modules, but this default is overwriten by the test environment.

## Requirements

This project requires Elixir version 1.11 and nothing more. If you have an older version of Elixir you can change it at `mix.exs` and probably it will still work fine.

The system was tested on Linux, but probably will work on MacOS and Windows too.

## Getting Started

1. Install the project dependencies. The only dependency that it has is `mock` and is required only for running tests, but you probably need to run the below command anyway.

```
$ mix deps.get
```

2. Start the Terminal Interface and follow the instructions.

```
$ mix start_terminal_interface
```

More information can be obtained by running:

```
$ mix help start_terminal_interface
```

## Testing

```
$ mix test
```

## Config

There are a few configuration options at `config/config.exs` that can be changed:

- typing_effect_print_time: There is a typing effect used by Terminal Interface. I found cool but if you get bored just change it to 0.
- user_reading_time: This is a time preconfigured to wait between some steps at the Terminal Interface to make the interface more user friendly.

You don't need to change the other settings, changing it will affect the functioning of the Terminal Interface.

## Contributing

We encourage you to contribute to NASA Exploration Rovers Control! Just submit a PR that we will be happy to review.

Wanna contribute and don't know where to start? There are some cool features in my mind:

- Prevent exploration rovers colisions
- The terminal interface could have the option to also receive the input commands by STDIO instead of only reading from files
- The terminal interface could print the commands that will be performed in a more readable and humanized format, this could help to prevent some mistakes

If you liked those ideas feel free to open a feature request issue or a PR. :stuck_out_tongue:

## Wtf?!

If you came this far and does not know why this crazy project was made, I'm happy that I've got your attention. :satisfied:

This was just an exercise made, and (at least for now :stuck_out_tongue_closed_eyes:) it has no real uses.

Thank you for the challenge, was real nice to work on it. :heart_eyes:
