%%% vim: set ts=4 sts=4 sw=4 expandtab:
-module(fbi_sdb_cache).

-export([
    add_flag/2,
    clear/1,
    delete_flag/2,
    get_flags_map/1,
    init_flags_map/1,
    flag/2
]).

add_flag(Name, Flag) ->
    try ets:insert(Name, {Flag, 1})
    catch _:_ -> ok
    end.

clear(Name) ->
    try ets:delete_all_objects(Name)
    catch _:_ -> ok
    end.

delete_flag(Name, Flag) ->
    try ets:delete(Name, Flag)
    catch _:_ -> ok
    end.

get_flags_map(Name) ->
    try ets:tab2list(Name)
    catch _:_ -> []
    end.

init_flags_map(Name) ->
    ets:new(Name, [named_table, public]).

flag(Name, Flag) ->
    try ets:lookup(Name, Flag) of
        [] -> false;
        [{_, _}] -> true
    catch _:_ -> false
    end.
