% 1942 Style Algebra Game (Aashish & Ryan) 

% Clear all
clc; 
clear; 
close all;

% Assigning sprite
blank_sprite = 1;
wall_sprite = 555;
player_sprite = 243;
proj_sprite = 12 * 32 + 13;
enemy_sprite = 23 * 32 + 16;

% Size of the game
NUM_ROWS = 20;
NUM_COLS = 20;

% Create the game scene
game_scene = simpleGameEngine("retro_pack.png", 16, 16, 10, [45, 45, 45]);

% Create the game
world = blank_sprite * ones(NUM_ROWS, NUM_COLS);

% Create a basic wall in the perimeter

for row = 1:NUM_COLS
    for col = 1: NUM_COLS
        % Check boundary conditions
        is_edge = (row == 1) || (row ==  NUM_COLS) || (col == 1) || (col == NUM_COLS);

        % Assign wall_sprite
        if is_edge
            world(row, col) = wall_sprite;
        end
    end
end

% Add divider between parts of the game
world(:, 15) = wall_sprite;

player_position = 3;

world(18, player_position) = player_sprite;
% Projectile state (plain variables, no classes)
proj_row = 4;
proj_col = 4;
proj_exists = true;

world(proj_row, proj_col) = proj_sprite;
world(3,4) = enemy_sprite;

drawScene(game_scene, world);

% Timing: how often the projectile steps, and how long each frame waits
PROJ_STEP_SECONDS = 0.25;
FRAME_SECONDS = 0.05;
proj_timer = tic;

while true
    % Player movement logic
    % Non-blocking read: guidata holds the key currently pressed on the
    % scene's figure, or 0 / empty when no key is down, so the loop keeps
    % running whether or not the player touches the keyboard
    key = guidata(game_scene.my_figure);

    if ischar(key) && strcmp(key, 'leftarrow')
        % Delete current player
        world (18, player_position) = blank_sprite;
        % Get new player position
        player_position = move_player(-1, player_position, world, wall_sprite);
    elseif ischar(key) && strcmp(key, 'rightarrow')
        % Delete current player
        world (18, player_position) = blank_sprite;
        % Get new player position
        player_position = move_player(1, player_position, world, wall_sprite);
    end

    %Set player position
    world(18, player_position) = player_sprite;

    % Projectile movement logic
    % Runs on its own clock, so the projectile falls on schedule no matter
    % what the player does
    if proj_exists && toc(proj_timer) >= PROJ_STEP_SECONDS
        % Restart the clock for the next step
        proj_timer = tic;

        % Erase the projectile from the cell it is leaving
        world(proj_row, proj_col) = blank_sprite;

        % Move it one unit down, or destroy it if it touches a wall
        [proj_row, proj_exists] = move_projectile(proj_row, proj_col, world, wall_sprite);

        % Only redraw it if it survived
        if proj_exists
            world(proj_row, proj_col) = proj_sprite;
        end
    end

    % Draw scene after inputs and actions complete
    drawScene(game_scene, world);

    % Short wait so the figure can process key presses and the game runs
    % at a steady speed instead of as fast as MATLAB can loop
    pause(FRAME_SECONDS);
end


% Function to move player
function result = move_player(distance, position, world, wall_sprite)
    result = position + distance;
    if world(3, result) == wall_sprite
        result = position;
    end
end


% Function to move the projectile one unit down.
% Outputs the projectile's new row and whether it still exists.
function [new_row, exists] = move_projectile(proj_row, proj_col, world, wall_sprite)
    exists = true;
    new_row = proj_row + 1;

    % If the next cell down is a wall (or past the bottom of the world),
    % the projectile touched a wall and ceases to exist
    if new_row > size(world, 1) || world(new_row, proj_col) == wall_sprite
        new_row = proj_row;
        exists = false;
    end
end
