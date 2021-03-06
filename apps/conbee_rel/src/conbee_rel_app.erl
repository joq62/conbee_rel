%%%-------------------------------------------------------------------
%% @doc conbee_rel public API
%% @end
%%%-------------------------------------------------------------------
-define(HwConfig,"hw.config").

-module(conbee_rel_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    case code:where_is_file(?HwConfig) of
	non_existing->
	    {error,[non_existing,?HwConfig]};
	AbsFilename ->
	    {ok,I}=file:consult(AbsFilename),
	    {conbee_addr,ConbeeAddr}=lists:keyfind(conbee_addr,1,I),
	    {conbee_port,ConbeePort}=lists:keyfind(conbee_port,1,I),
	    {conbee_key,ConbeeKey}=lists:keyfind(conbee_key,1,I),
	    ok=application:set_env([{conbee_rel,[{addr,ConbeeAddr},{port,ConbeePort},{key,ConbeeKey}]}]),
	    conbee_rel_sup:start_link()
    end.

stop(_State) ->
    ok.

%% internal functions
