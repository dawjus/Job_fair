# Job Fair Assignment

Assignment problem related to the job fair.

Made for ACP'16 Summer School in Cork by The Insight Centre for Data Analytics.


## Problem Details

Imagine a job fair at the AGH UST in Krakow. It's marvelous, full of great SWAG and career opportunities. 
This year it will be even better, because we will optimize the schedule that every participant, both jobless students and greedy companies, would be as happy as possible.

So, first, the job fair is held for `5` consecutive days, each day there are `4` time slots, when students can be hunted/interviews, so in total there are `20` timeslots.
`1`'st, `2`'nd, `3`'rd and `4`'th slots belong to the first day, `5`'th to second, `9`'th to third, etc.

Each interview is held in a separate room, so if there are two inteviews happening at the same time slot, you need two rooms and so on. The rooms have to be rented beforehand and can be rented only for the whole fair. In other words, it is enough that at one particular time seven rooms are needed, you have to rent seven for the whole fair. Cost of the rent is `200` per room.

To make the fair a bit more fair (pun intended) and interesting, each student has to participate in `3` interviews, each with different company. Obviously student can be interviewed only by a single company at the same time. Also at least one of the interviewing companies has to be in the student's "top 3" (preference has to be less or equal to the third lowest preference in the student's preferences list), otherwise the student may feel cheated. 

### Parameters

Those numbers above are constant and same for every problem instance, now let's move to the parameters building the data file:
* `n_students` — how many jobless students will attend the fair
* `n_companies` — how many greedy companies will hunt them
* `preferences` — a 2d array `n_students ✕ n_companies` of integral numbers in range `1..5`, where `1` at index `[i,j]` means, that student `i` would really love to work at company `j`, while `5` indicates they aren't really interested
* `best_expectations` — it's a 1d array of size `n_students` containing numbers in range `3..15`. Number `3` at index `i` says that students `i` expects to meet three companies he sees as the best (`1` in the preference matrix)
* `min_capacities` — it's a 1d array of size `n_companies` pointing at minimum number of candidates each greedy company wants to process
* `max_capacities` — similar to `min_capacities`, but shows how many candidates each company is able to process in total
* `attendance_costs` — each soulless company pays AGH so it could hunt for the poor souls. This array shows how much it has to pay per day. One could save a lot of money by staying only a single day. Companies have to come to Kraków for their first scheduled interview, then stay at Kraków till their last scheduled interview.
* `parallel_limits` — every company delegates some HR workers to be hunters. This array show how many hunters have been delegated, ie. how many candidates can the company process in parallel.
* `slots` — an array that contains for each student a set of time slots they are able to attend (all the remaining time they have classes/parties or both)

### Objective

The optimization objective is to minimize sum of three components:
- total room cost — number of required rooms multiplied by the rent price
- total attendance cost — sum of money companies have to pay for the time spent at the fair (number of days they have to spend in Krakow `✕` attendance cost)
- total disappointment value — where student's disappointment is defined as difference between sum of his interviews' preferences and his best expectations. If the interviews exceed his expectations, the disappointment equals `0`.

## Output

The output format is pretty simple and prints in order assigned companies and time slots for each interview. The rooms can assigned later by a very smart AGH employee ;)
The order in the output arrays is also simple: 

1. 1st student's 1st interview
2. 1st student's 2nd interview
3. 1st student's 3rd interview
4. 2nd student's 1st interview
5. 2nd student's 2nd interview
6. ...

Below that one should print the total objective value and the three cost components.

An example output for data `4_4` is presented below:

```
companies = [1, 2, 3, 1, 3, 4, 1, 2, 4, 1, 2, 3];
timeslots = [15, 16, 19, 5, 6, 4, 7, 11, 2, 9, 10, 8];
objective = 392;
total_room_cost = 200;
total_attendance_cost = 170;
total_disappointment_value = 22;
```

