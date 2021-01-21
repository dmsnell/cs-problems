-module(cake_thief).
-author("Dennis Snell <dmsnell@acm.org>").

-include_lib("eunit/include/eunit.hrl").

-record(cake, {weight :: non_neg_integer(), price :: non_neg_integer()}).

-export([
    cake/2,
    max_duffel_bag_value/2
]).

%% Interface functions

-spec max_duffel_bag_value(Capacity, CakeTypes) -> {non_neg_integer(), gbp}
    when Capacity  :: non_neg_integer(),
         CakeTypes :: list(#cake{}).

max_duffel_bag_value(Capacity, CakeTypes) when is_list(CakeTypes) ->
    {maximize(CakeTypes, Capacity, 0), gbp}.

-spec cake({non_neg_integer(), kg}, {non_neg_integer(), gbp}) -> #cake{}.

cake({Weight, kg}, {Price, gbp}) -> #cake{weight = Weight, price = Price}.

%% Internal functions

maximize(CakeTypes, Capacity, Price) when is_list(CakeTypes) ->
    lists:max([maximize(CakeTypes, Capacity, Price, Cake) || Cake <- CakeTypes]).

maximize(CakeTypes, Capacity, Price, #cake{weight = W, price = P}) when Capacity >= W ->
    maximize(CakeTypes, Capacity - W, Price + P);
maximize(_CakeTypes, Capacity, Price, #cake{weight = W}) when Capacity < W ->
    Price.

-ifdef(EUNIT).

example1_test() ->
    ?assertEqual({555, gbp}, max_duffel_bag_value(20, [
        cake({7, kg}, {160, gbp}),
        cake({3, kg}, {90, gbp}),
        cake({2, kg}, {15, gbp})
    ])).

-endif.