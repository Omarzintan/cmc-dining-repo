globals
[
  collins-patches
  food-truck-patches
  campus-patches
  max-people-collins
  max-people-food-truck
  collins-attendance
  food-truck-attendance
  collins-crowd-threshold
  food-trucks-crowd-threshold
  collins-crowdedness-duration
  food-truck-crowdedness-duration
]
turtles-own
[
  time-to-search-for-food
  in-eating-area
  location-preference
  influence
  wiggle-angle
  time-start-eating
]
patches-own
[]

to setup
  clear-all
  ;; create the food trucks -> want to move this to the middle.
  set food-truck-patches patches with [pxcor > 40 and pycor < -60]
  ;;set food-truck-patches patches with [pxcor <= 40 and pxcor > 0 and pycor < -60]
  ask food-truck-patches [set pcolor 68]

  ;; create collins 60m by 30m -> want to move this to the middle.
  set collins-patches patches with [pxcor > 40 and pycor > 70]
  ask collins-patches [set pcolor 18]
  ;; set patches for campus
  set campus-patches patches with [pxcor < 40 or (pycor < 70 and pycor > -60)]
  ask campus-patches [set pcolor white]

  ;; create students of the different categories (A, B, C)
  set-default-shape turtles "person"
  create-category-of-students 13 collins-patches
  create-category-of-students green food-truck-patches

  ;; Set crowd thresholds for the various locations
  ;; this is calculated by taking 60% of the capacity of the location
  set collins-crowd-threshold 210
  set food-trucks-crowd-threshold 124
  reset-ticks ;start clock
end

to go
  if ticks = 200
  [stop]
  set collins-attendance count turtles-on collins-patches
  set food-truck-attendance count turtles-on food-truck-patches
  if collins-attendance > max-people-collins
  [set max-people-collins collins-attendance]
  if food-truck-attendance > max-people-food-truck
  [set max-people-food-truck food-truck-attendance]
  ;; update values that indicate how long the locations are crowded for
  if collins-attendance >= collins-crowd-threshold
  [ set collins-crowdedness-duration (collins-crowdedness-duration + 1)]
  if food-truck-attendance >= food-trucks-crowd-threshold
  [ set food-truck-crowdedness-duration (food-truck-crowdedness-duration + 1)]
;; tell turtle to move randomly if its time-to-search-for-food has not been called yet
 ask turtles [
  ifelse ticks >= time-to-search-for-food
  [search-for-food location-preference]
  [random-movement]
  ]
 tick ; add to the clock

end

to move-to-empty-one-of [locations]
  move-to one-of locations
  while [any? other turtles-here] [
    move-to one-of locations
  ]
end

to create-category-of-students [category-color location]
  set-default-shape turtles "person"
  create-turtles 665 [
    set color category-color
    set location-preference location
    set size 5
    set time-to-search-for-food round random-normal 90 45 ;;gives each turtle a normal distribution of random values with a mean of 90 and a stdev of 1
    if time-to-search-for-food < 0 [set time-to-search-for-food 0]
    if time-to-search-for-food > 180 [set time-to-search-for-food 180]
    move-to-empty-one-of campus-patches
  ]
end

to random-movement
    ;; make sure turtles don't jump to the end locations.
    right random 360
    forward 1
end

to search-for-food [name-of-patches]
  ifelse pcolor = white or pcolor = grey or pcolor = black
  [
    face one-of name-of-patches
    forward 5
  ]
  [
    if in-eating-area != true
    [set time-start-eating ticks]
    set in-eating-area true
    eat name-of-patches
  ]
end

to eat [name-of-patches]

  ifelse ticks > time-start-eating + 45
  [die]
  [move-to-empty-one-of name-of-patches]
end