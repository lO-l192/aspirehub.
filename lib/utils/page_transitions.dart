import 'package:flutter/material.dart';

/// A custom page route that provides smooth transitions between screens
class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final SlideDirection direction;
  
  SlidePageRoute({
    required this.page,
    this.direction = SlideDirection.right,
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = direction == SlideDirection.right
          ? const Offset(1.0, 0.0)
          : direction == SlideDirection.left
              ? const Offset(-1.0, 0.0)
              : direction == SlideDirection.up
                  ? const Offset(0.0, 1.0)
                  : const Offset(0.0, -1.0);
                  
      var end = Offset.zero;
      var curve = Curves.easeInOutCubic;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      
      return SlideTransition(
        position: offsetAnimation,
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

/// A custom page route that provides a fade transition between screens
class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  
  FadePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
}

/// A custom page route that provides a scale transition between screens
class ScalePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  
  ScalePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var curve = Curves.easeInOutCubic;
            var scaleTween = Tween(begin: 0.8, end: 1.0).chain(CurveTween(curve: curve));
            var opacityTween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
            
            return ScaleTransition(
              scale: animation.drive(scaleTween),
              child: FadeTransition(
                opacity: animation.drive(opacityTween),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
}

/// Enum to define the slide direction for SlidePageRoute
enum SlideDirection {
  left,
  right,
  up,
  down,
}

/// Extension method to add navigation methods to BuildContext
extension NavigationExtension on BuildContext {
  /// Navigate to a new screen with a slide transition
  Future<T?> slideToPage<T>(Widget page, {SlideDirection direction = SlideDirection.right}) {
    return Navigator.push<T>(
      this,
      SlidePageRoute<T>(
        page: page,
        direction: direction,
      ),
    );
  }

  /// Navigate to a new screen with a fade transition
  Future<T?> fadeToPage<T>(Widget page) {
    return Navigator.push<T>(
      this,
      FadePageRoute<T>(
        page: page,
      ),
    );
  }

  /// Navigate to a new screen with a scale transition
  Future<T?> scaleToPage<T>(Widget page) {
    return Navigator.push<T>(
      this,
      ScalePageRoute<T>(
        page: page,
      ),
    );
  }
  
  /// Replace the current screen with a new one using a slide transition
  Future<T?> slideToReplacementPage<T>(Widget page, {SlideDirection direction = SlideDirection.right}) {
    return Navigator.pushReplacement<T, dynamic>(
      this,
      SlidePageRoute<T>(
        page: page,
        direction: direction,
      ),
    );
  }

  /// Replace the current screen with a new one using a fade transition
  Future<T?> fadeToReplacementPage<T>(Widget page) {
    return Navigator.pushReplacement<T, dynamic>(
      this,
      FadePageRoute<T>(
        page: page,
      ),
    );
  }

  /// Replace the current screen with a new one using a scale transition
  Future<T?> scaleToReplacementPage<T>(Widget page) {
    return Navigator.pushReplacement<T, dynamic>(
      this,
      ScalePageRoute<T>(
        page: page,
      ),
    );
  }
}
