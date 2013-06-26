-module(slg_proto).
-compile([export_all]).

start() ->
  application:start(slg_proto),
  conn_super:heartbeat(),
  ok.

