%%%-------------------------------------------------------------------
%% @doc conbee_rel public API
%% @end
%%%-------------------------------------------------------------------
-define(ConbeeAddr,"172.17.0.2").
-define(ConbeePort,80).
-define(Crypto,"D83FA13F74").


-module(conbee_rel_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    ok=application:set_env([{conbee_rel,[{addr,?ConbeeAddr},{port,?ConbeePort},{crypto,?Crypto}]}]),
    conbee_rel_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
