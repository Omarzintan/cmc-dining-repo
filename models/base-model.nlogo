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
  food-trucks-crowd-threshold
  collins-crowdedness-duration
  food-truck-crowdedness-duration
]
turtles-own
[
  time-to-search-for-food
  in-eating-area
  location-preference
  i-was-influenced
  wiggle-angle
  time-start-eating
  eating-duration
]
patches-own
[
  collins-crowdedness
  food-truck-crowdedness
  distance-from-location
]

to setup
  clear-all
  ;; create the food trucks -> want to move this to the middle.
  set food-truck-patches patches with [pxcor > 40 and pycor < -60]
  ;;set food-truck-patches patches with [pxcor <= 40 and pxcor > 0 and pycor < -60]
  ask food-truck-patches [set pcolor 68];;makes them light green

  ;; create collins 60m by 30m -> want to move this to the middle.
  set collins-patches patches with [pxcor > 40 and pycor > 70]
  ask collins-patches [set pcolor 18];makes collins patches light red
  ;; set patches for campus
  set campus-patches patches with [pxcor < 40 or (pycor < 70 and pycor > -60)]
  ask campus-patches [set pcolor white]

  ;; create students of the different categories (A, B, C)
  set-default-shape turtles "person"
  create-category-of-students 13 collins-patches ;;dark red
  create-category-of-students green food-truck-patches ;; dark yellow
  ;; campus patches below is just a place holder
  create-category-of-students blue campus-patches

  ;; Create patches from which agents can receive information on how crowded
  ;; the dining hall and food truck are.
  create-crowdedness-range

  ;; Set crowd threshold for the food-truck based on crowding threshold for collins
  ;; and threshold ratio
  set food-trucks-crowd-threshold round (collins-crowd-threshold * thresholds-ratio)
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
 ask turtles
  [
    meet
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
  create-turtles 443 [
    set color category-color
    set size 5
    set time-to-search-for-food round random-normal 90 45 ;;gives each turtle a normal distribution of random values with a mean of 90 and a stdev of 45
    set eating-duration round random-normal 45 20
    if time-to-search-for-food < 0 [set time-to-search-for-food 0]
    if time-to-search-for-food > 180 [set time-to-search-for-food 180]
    if eating-duration < 15 [set eating-duration 15]
    if eating-duration > 90 [set eating-duration 90]
    move-to-empty-one-of campus-patches
    ifelse category-color = blue
    [
      let closest-patch min-one-of (patches with [pcolor = 18 or pcolor = 48])[distance myself]
      ifelse [pcolor] of closest-patch = 18
      [set location-preference collins-patches]
      [set location-preference food-truck-patches]
    ]
    [set location-preference location]
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

to meet    ;; turtle procedure - when two turtles are next door,
           ;; if one of the turtles is blue in color, it changes
           ;; color to its neighbor's color.
           ;; note: candidate is currently only considering turtles
           ;; to the left of the current turtle.
  if color = blue
  [
    let candidate one-of turtles-at 1 0
    if candidate != nobody and [color] of candidate != blue
    [
      set color [color] of candidate
      set location-preference [location-preference] of candidate
      set i-was-influenced true
    ]
  ]
end