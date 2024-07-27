import 'package:flutter/material.dart';

/// An abstract class representing the main navigation functionality.
abstract class MainNavigation {}

/// A mixin that provides navigation functionality to a [State] class.
/// Classes that use this mixin must extend [State] and implement
/// [MainNavigation].
mixin MainNavigationMixin<T extends StatefulWidget> on State<T>
    implements MainNavigation {}
