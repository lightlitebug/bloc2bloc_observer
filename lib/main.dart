import 'package:bloc2bloc/observers/color_bloc_observer.dart';
import 'package:bloc2bloc/observers/counter_bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/color/color_bloc.dart';
import 'blocs/counter/counter_bloc.dart';

void main() {
  // BlocOverrides.runZoned(
  //   () {
  //     runApp(const MyApp());
  //   },
  //   blocObserver: ColorBlocObserver(),
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ColorBloc>(
          create: (context) => ColorBloc(),
        ),
        BlocProvider<CounterBloc>(
          create: (context) => CounterBloc(
            colorBloc: context.read<ColorBloc>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'bloc2bloc',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BlocOverrides.runZoned(
        () => context.watch<ColorBloc>().state.color,
        blocObserver: ColorBlocObserver(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text(
                'Change Color',
                style: TextStyle(fontSize: 24.0),
              ),
              onPressed: () {
                context.read<ColorBloc>().add(ChangeColorEvent());
              },
            ),
            SizedBox(height: 20.0),
            BlocOverrides.runZoned(
              () {
                return Text(
                  '${context.watch<CounterBloc>().state.counter}',
                  style: TextStyle(
                    fontSize: 52.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              },
              blocObserver: CounterBlocObserver(),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              child: Text(
                'Increment Counter',
                style: TextStyle(fontSize: 24.0),
              ),
              onPressed: () {
                context.read<CounterBloc>().add(ChangeCounterEvent());
              },
            ),
          ],
        ),
      ),
    );
  }
}
