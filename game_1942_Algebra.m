% 1942 Style Algebra Game (Aashish & Ryan) 

% Clear all
clc; 
clear; 
close all;

% Assigning sprite
blank_sprite = 1;
wall_sprite = 555;

% Size of the game
NUM_ROWS = 20;
NUM_COLS = 40; % 30-> Game screen, 10-> qn screen

% Create the game scene
game_scene = simpleGameEngine("retro_pack.png", 16, 16, 20, [45, 45, 45]);

% Create the game
world = blank_sprite * ones(NUM_ROWS, NUM_COLS);

% Create a basic wall in the perimeter

for row = 1:NUM_ROWS
    for col = 1: NUM_COLS
        % Check boundary conditions
        is_edge = (row == 1) || (row ==  NUM_ROWS) || (col == 1) || (col == NUM_COLS);

        % Assign wall_sprite
        if is_edge
            world(row, col) = wall_sprite;
        end
    end
end

% Add wall to seperate game and qn screen
world(:, 30) = wall_sprite;

drawScene(game_scene, world);
