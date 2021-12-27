start_A_star(InitState, PathCost, N) :-
	score(InitState, 0, 0, InitCost, InitScore) ,
	search_A_star( [node(InitState, nil, nil, InitCost , InitScore ) ], [ ], PathCost, N) .


search_A_star(Queue, ClosedSet, PathCost, N) :-
	new_fetch(Nodes, Queue, ClosedSet, N),
    write("Nodes: "), write(Nodes), nl,
    writeln('Podaj kolejnosc wezlow'), nl,
    read(OrderList),
    getNodeNumber(OrderList, NodeNumber),
    getNElementOfList(Nodes, NodeNumber, Node),
    write("---"),nl, 
    write("Aktualna kolejka: "), write(Queue), nl,
    write("POBIERAM WĘZEŁ: "), write(Node), nl,
    write("ClosedSet: "), write(ClosedSet), nl,
	continue(Node, Queue, ClosedSet, PathCost, N).

continue(node(State, Action, Parent, Cost, _), _, ClosedSet, path_cost(Path, Cost), _ ) :-
	goal( State), !,
	build_path(node(Parent, _ ,_ , _ , _ ) , ClosedSet, [Action/State], Path) .

continue(Node, RestQueue, ClosedSet, Path, N)   :-
	expand( Node, NewNodes),
	insert_new_nodes(NewNodes, RestQueue, NewQueue),
	search_A_star(NewQueue, [Node | ClosedSet ], Path, N).

new_fetch([], [], _, _).

new_fetch([], _, _, 0).

new_fetch([node(State, Action,Parent, Cost, Score)|RestResult],
[node(State, Action,Parent, Cost, Score)|RestQueue], ClosedSet, N) :-
  \+ member(node(State, _, _, _, _), ClosedSet), !,
  NN is N-1,
  new_fetch(RestResult, RestQueue, ClosedSet, NN).

new_fetch([Node|RestResult], [ _ |RestQueue], ClosedSet, N) :-
  new_fetch([Node|RestResult], RestQueue, ClosedSet , N).

expand(node(State, _ ,_ , Cost, _ ), NewNodes)  :-
	findall(node(ChildState, Action, State, NewCost, ChildScore) ,
			(succ(State, Action, StepCost, ChildState),
			    score(ChildState, Cost, StepCost, NewCost, ChildScore)),
			NewNodes).


score(State, ParentCost, StepCost, Cost, FScore)  :-
	Cost is ParentCost + StepCost ,
	hScore(State, HScore),
	FScore is Cost + HScore.


insert_new_nodes( [ ], Queue, Queue).

insert_new_nodes( [Node|RestNodes], Queue, NewQueue) :-
	insert_p_queue(Node, Queue, Queue1),
	insert_new_nodes( RestNodes, Queue1, NewQueue).


insert_p_queue(Node, [ ], [Node]) :- !.

insert_p_queue(node(State, Action, Parent, Cost, FScore),
		[node(State1, Action1, Parent1, Cost1, FScore1)|RestQueue],
			[node(State1, Action1, Parent1, Cost1, FScore1)|Rest1] )  :-
	FScore >= FScore1,  ! ,
	insert_p_queue(node(State, Action, Parent, Cost, FScore), RestQueue, Rest1).

insert_p_queue(node(State, Action, Parent, Cost, FScore),  Queue,
				[node(State, Action, Parent, Cost, FScore)|Queue]).

build_path(node(nil, _, _, _, _), _, Path, Path) :- !.

build_path(node(EndState, _, _, _, _), Nodes, PartialPath, Path) :-
	del(Nodes, node(EndState, Action, Parent, _, _), Nodes1) ,
	build_path( node(Parent,_ ,_ , _ , _ ) , Nodes1, [Action/EndState|PartialPath],Path).

del([X|R],X,R).
del([Y|R],X,[Y|R1]) :-
	X\=Y,
	del(R,X,R1).

getNodeNumber([Node | _], Node).

getNodeNumber([_|List], Node) :-
	getNodeNumber(List, Node).

getNElementOfList([], _, []).

getNElementOfList([_|List], NumberOfElement, Y) :-
	NumberOfElement2 is NumberOfElement - 1,
	NumberOfElement2 >= 1,
	getNElementOfList(List, NumberOfElement2, Y).

getNElementOfList([Y|_], 1, Y).


succ(a, ab, 2, b).
succ(b, bf, 3, f).
succ(a, ac, 3, c).
succ(b, bg, 4, g).
succ(g, gm, 2, m).
succ(c, cd, 2, d).
succ(d, dm, 2, m).
succ(c, ce, 3, e).
succ(e, em, 5, m).

goal(m).

hScore(a, 4).
hScore(b, 4).
hScore(f, 7).
hScore(g, 1).
hScore(m, 0).
hScore(c, 3).
hScore(d, 1).
hScore(e, 4).
