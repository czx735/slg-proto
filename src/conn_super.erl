%%% ==================================================================
%%% @author zhuoyikang
%%% 网络端口进程监督者
%%% ==================================================================
-module(conn_super).
-behaviour(supervisor).

%% API
-export([init/1, start_player/1, heartbeat/0, all_player/0]).

-define(MAX_RESTART, 5000000).
-define(MAX_TIME, 60).

%% 开启一个连接服务进程.
start_player(Port) ->
  supervisor:start_child(?MODULE, [Port]).

heartbeat() ->
  All = supervisor:which_children(?MODULE),
  lists:foreach(fun({undefined, Pid, worker, []}) ->
                    conn:heartbeat(Pid)
                end, All),
  timer:apply_after(60000, ?MODULE, heartbeat, []),
  ok.

%% 返回所有的玩家进程列表
all_player() ->
  All = supervisor:which_children(?MODULE),
  [Pid || {undefined, Pid, worker, []} <- All].

init([]) ->
  {ok,
   {_SupFlags = {simple_one_for_one, ?MAX_RESTART, ?MAX_TIME},
    [{undefined, {conn, start_link, []}, temporary, 2000, worker, []}]
   }
  }.
