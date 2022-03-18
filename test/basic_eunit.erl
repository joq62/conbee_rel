%%% -------------------------------------------------------------------
%%% @author  : Joq Erlang
%%% @doc: : 
%%% Created :
%%% Node end point  
%%% Creates and deletes Pods
%%% 
%%% API-kube: Interface 
%%% Pod consits beams from all services, app and app and sup erl.
%%% The setup of envs is
%%% -------------------------------------------------------------------
-module(basic_eunit).   
 
-export([start/0]).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").
-include_lib("kernel/include/logger.hrl").
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
-define(ApiKey,D83FA13F74).

start()->
    ok=application:start(conbee_rel),
    pong=conbee:ping(),
    application:ensure_all_started(gun),
    ok=t0_test(),
   % curl_test(),
    pass_0_test(),
   % t2(),

   % init:stop(),
    ok.

% 21B8A3D920

t2()->
    % http://172.17.0.2:80/api/9FC8DF92DC/lights/2/state    
    % {"on":true}
    ok.
t0_test()->
    
    ok.
curl_test()->
    Link="172.17.0.2",
    Cmd = "curl -s GET \"" ++ Link ++ "\"",
    Output = os:cmd(Cmd),
    io:format("Output ~p~n",[{Output,?MODULE,?LINE}]),
    Output.

pass_0_test()->
    inets:start(),
    {ok, {{Version, 200, ReasonPhrase}, Headers, Body}} =
      httpc:request(get,{"https://phoscon.de/discover",[]},[],[{body_format,binary}]),
    %gl=Body,
    Map=jsx:decode(Body,[]),
 %   io:format("Map ~p~n",[Map]),
    
    io:format("************~p ****************~n",[time()]),
   % init:stop(),
   % timer:sleep(3000),
    Info=sensors:get_info(),  
 %   Info=sensors:get_info("192.168.0.100",8080,"/api/0BDFAC94EE/sensors"),     
%    io:format("Info ~p~n",[Info]),
    Sensors=[{Type,Id,Key,Value}||[{name,Name},{id,Id},{type,Type},{status,{Key,Value}}]<-Info],
    Sorted=lists:keysort(2,Sensors),
    [io:format("~p~n",[Sensor])||Sensor<-Sorted],
    io:format("----------------------------------------------~n"),
%  glurk=Raw=conbee:sensors_raw(),    
 %   io:format("Raw ~p~n",[Raw]),
%    io:format("indoor_temp_1 ~p~n",[Raw]),
    
%-------- lights
    LightInfo=lights:get_info(),    
  %  LightInfo=lights:get_info("192.168.0.100",8080,"/api/0BDFAC94EE/lights"),    
%    io:format("Info ~p~n",[Info]),
    Lights=[{Type,Id,Key,Value}||[{name,Name},{id,Id},{type,Type},{status,{Key,Value}}]<-LightInfo],
    SortedLights=lists:keysort(2,Lights),
    [io:format("~p~n",[Light])||Light<-SortedLights],
    io:format("----------------------------------------------~n"),
 
    io:format("temp_main_house  ~p~n",[varmdo_mm:temp_main_house()]),
    io:format("door_main  ~p~n",[varmdo_mm:door_main()]),
    io:format("presence_hall ~p~n",[varmdo_mm:presence_hall()]),
    ok.

   % timer:sleep(10*1000),
   % pass_0().
    

t1_test()->
  

    ok.


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------



%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
