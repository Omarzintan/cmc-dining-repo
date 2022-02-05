globals
[
  collins-patches
  food-truck-patches
  campus-patches
  max-people-collins
  max-people-food-truck
  left-side-of-collins-patches
  bottom-side-of-collins-patches
  left-side-of-food-truck-patches
  top-side-of-food-truck-patches
  collins-attendance
  food-truck-attendance
  collins-crowd-threshold
  food-trucks-crowd-threshold
  collins-crowded-patch
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
  eating-duration
]
patches-own
[
  collins-crowdedness
  food-truck-crowdedness
  distance-from-location
  crowdedness-duration
]

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

  ask patch (0.75 * max-pxcor) (0.15 * max-pycor) [
    set collins-crowded-patch self
    set plabel-color green
  ]

  ;; create students of the different categories (A, B, C)
  set-default-shape turtles "person"
  create-category-of-students 13 collins-patches
  create-category-of-students green food-truck-patches

  ;; Create patches from which agents can receive information on how crowded
  ;; the dining hall and food truck are.
  create-crowdedness-range

  ;; Set crowd thresholds for the various locations
  set collins-crowd-threshold 210
  set food-trucks-crowd-threshold 124
  reset-ticks ;start clock
end

to go
  calculate-crowdedness
  if ticks = 200
  [stop]
  if count turtles-on collins-patches > max-people-collins
  [set max-people-collins count turtles-on collins-patches]
  if count turtles-on food-truck-patches > max-people-food-truck
  [set max-people-food-truck count turtles-on food-truck-patches]
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
    set time-to-search-for-food round random-normal 90 45 ;;gives each turtle a normal distribution of random values with a mean of 90 and a stdev of 45
    set eating-duration round random-normal 45 20
    if time-to-search-for-food < 0 [set time-to-search-for-food 0]
    if time-to-search-for-food > 180 [set time-to-search-for-food 180]
    if eating-duration < 15 [set eating-duration 15]
    if eating-duration > 90 [set eating-duration 90]
    move-to-empty-one-of campus-patches
  ]
end

to random-movement
    ;; make sure turtles don't jump to the end locations.
    right random 360
    forward 1
end

to search-for-food [destination-patches]
  ifelse pcolor = white or pcolor = grey or pcolor = black
  [
    if destination-patches = collins-patches
    [
      if collins-crowdedness >= collins-crowd-threshold
      [
        set location-preference food-truck-patches
      ]
    ]
    if destination-patches = food-truck-patches
    [
      if food-truck-crowdedness >= food-trucks-crowd-threshold
      [
        set location-preference collins-patches
      ]
    ]
    face one-of location-preference
    forward 5
  ]
  [
    if in-eating-area != true
    [set time-start-eating ticks]
    set in-eating-area true
    eat location-preference
  ]
end

to eat [name-of-patches]

  ifelse ticks > time-start-eating + eating-duration
  [die]
  [move-to-empty-one-of name-of-patches]
end

to calculate-crowdedness
  ;; get how many turtles are in the dining hall
  set collins-attendance count turtles-on collins-patches
  ;; get how many turtles are at the food truck
  set food-truck-attendance count turtles-on food-truck-patches
  ;; update values that indicate how long the locations are crowded for
  if collins-attendance >= collins-crowd-threshold
  [ set collins-crowdedness-duration (collins-crowdedness-duration + 1)]
  if food-truck-attendance >= food-trucks-crowd-threshold
  [ set food-truck-crowdedness-duration (food-truck-crowdedness-duration + 1)]
  ;; set the crowdedness value for patches surrounding the eating locations.
  ask-concurrent left-side-of-collins-patches [ set collins-crowdedness round (collins-attendance * (1 - 0.005) ^ distance-from-location) ]
  ask-concurrent bottom-side-of-collins-patches [ set collins-crowdedness round (collins-attendance * (1 - 0.005) ^ distance-from-location) ]
  ask-concurrent left-side-of-food-truck-patches [ set food-truck-crowdedness round (food-truck-attendance * (1 - 0.005) ^ distance-from-location) ]
  ask-concurrent top-side-of-food-truck-patches [ set food-truck-crowdedness round (food-truck-attendance * (1 - 0.005) ^ distance-from-location) ]
end

to create-crowdedness-range
  ;; Create patches around Collins from which agents can receive info on how crowded Collins is.
  set left-side-of-collins-patches patches with [(pxcor >= 10 and pxcor < 40 and pycor >= 40)]
  set bottom-side-of-collins-patches patches with [(pxcor >= 40 and pycor >= 40 and pycor < 70)]

  ;; Create patches around the food truck from which agents can receive info on how crowded the food truck is.
  set left-side-of-food-truck-patches patches with [(pxcor >= 10 and pxcor < 40 and pycor <= -30)]
  set top-side-of-food-truck-patches patches with [(pxcor >= 40 and pycor <= -30 and pycor > -60)]

  ;; Set the color of these patches to grey
  ask left-side-of-collins-patches [set pcolor grey]
  ask bottom-side-of-collins-patches [set pcolor grey]
  ask left-side-of-food-truck-patches [set pcolor grey]
  ask top-side-of-food-truck-patches [set pcolor grey]

  ;; Set the distance levels of the patches
  ask-concurrent left-side-of-collins-patches [ set distance-from-location max(list 0 ((round distance patch 70 85) - 23))]
  ask-concurrent bottom-side-of-collins-patches [ set distance-from-location max(list 0 ((round distance patch 70 85) - 23))]
  ask-concurrent left-side-of-food-truck-patches [ set distance-from-location max(list 0 ((round distance patch 70 -80) - 25))]
  ask-concurrent top-side-of-food-truck-patches [ set distance-from-location max(list 0 ((round distance patch 70 -80) - 25))]
end