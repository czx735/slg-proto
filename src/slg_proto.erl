-module(slg_proto).
-compile([export_all]).

%% 产生配置模块
gen_module(CallBack, Port) ->
  M1 = spt_smerl:new(slg_proto_conf),
  F1 = "callback() -> " ++ atom_to_list(CallBack) ++ ".",
  F2 = "port() -> " ++ integer_to_list(Port) ++ ".",
  {ok, M2} = spt_smerl:add_func(M1, F1),
  {ok, M3} = spt_smerl:add_func(M2, F2),
  spt_smerl:compile(M3).

start(CallBack, Port) ->
  gen_module(CallBack, Port),
  application:start(slg_proto),
  conn_super:heartbeat(),
  ok.

start() ->
  start(slg_proto, 4000).
