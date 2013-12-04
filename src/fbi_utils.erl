-module(fbi_utils).

-export([
    atom_for_realm/2,
    parse_key/1
]).

atom_for_realm(Name, Realm) ->
    SName = atom_to_list(Name),
    SRealm = atom_to_list(Realm),
    SRes = case SRealm of
        "rm_" ++ Suffix -> SName ++ "_" ++ Suffix;
        _ -> SName ++ "_" ++ SRealm
    end,
    list_to_atom(SRes).

parse_key(Key) ->
    Tokens = string:tokens(Key, "/"),
    lists:map(fun parse_token/1, Tokens).

parse_token([$< | R] = Token) ->
    case lists:reverse(R) of
        [$> | T] -> hex_to_binary_rev(T);
        _ -> Token
    end;
parse_token(Token) -> Token.

hex_to_binary_rev(T) ->
    list_to_binary(hex_to_binary_rev_ll(T)).

hex_to_binary_rev_ll([]) -> [];
hex_to_binary_rev_ll([L, H | T]) ->
    hex_to_binary_rev_ll(T) ++ [int(H) * 16 + int(L)].

int(C) when $0 =< C, C =< $9 ->
    C - $0;
int(C) when $A =< C, C =< $F ->
    C - $A + 10;
int(C) when $a =< C, C =< $f ->
    C - $a + 10.

