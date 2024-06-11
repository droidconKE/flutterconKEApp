part of 'fluttercon_bloc.dart';

enum FlutterconStatus { initial, loading, refreshing, success, failure }

class FlutterconState extends Equatable {
  const FlutterconState({
    this.status = FlutterconStatus.initial,

    this.errorMessage,

    /// -------------------------- Feed Related Settings --------------------------
    // Default Listing/Sort Settings
    this.defaultListingType = ListingType.list,

    // Tablet Settings
    this.tabletMode = false,

    // Theme Settings
    this.themeType = ThemeType.system,
    //this.selectedTheme = CustomThemeType.deepBlue,
    this.useMaterialYouTheme = false,

  });

  final FlutterconStatus status;
  final String? errorMessage;

  /// -------------------------- Feed Related Settings --------------------------
  // Default Listing/Sort Settings
  final ListingType defaultListingType;
  
  // Tablet Settings
  final bool tabletMode;

  /// -------------------------- Theme Related Settings --------------------------
  // Theme Settings
  final ThemeType themeType;
  final bool useMaterialYouTheme;

  FlutterconState copyWith({
    FlutterconStatus? status,
    String? errorMessage,

    /// -------------------------- Feed Related Settings --------------------------
    // Default Listing/Sort Settings
    ListingType? defaultListingType,
    bool? useProfilePictureForDrawer,

    // Tablet Settings
    bool? tabletMode,

    /// -------------------------- Theme Related Settings --------------------------
    // Theme Settings
    ThemeType? themeType,
    bool? useMaterialYouTheme,

  }) {
    return FlutterconState(
      status: status ?? this.status,
      errorMessage: errorMessage,

      /// -------------------------- Feed Related Settings --------------------------
      /// Default Listing/Sort Settings
      defaultListingType: defaultListingType ?? this.defaultListingType,
      
      // Tablet Settings
      tabletMode: tabletMode ?? this.tabletMode,

      /// -------------------------- Theme Related Settings --------------------------
      // Theme Settings
      themeType: themeType ?? this.themeType,
      useMaterialYouTheme: useMaterialYouTheme ?? this.useMaterialYouTheme,

    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,

        /// -------------------------- Feed Related Settings --------------------------
        /// Default Listing/Sort Settings
        defaultListingType,
        
        // Tablet Settings
        tabletMode,

        /// -------------------------- Theme Related Settings --------------------------
        // Theme Settings
        themeType,
        useMaterialYouTheme,

      ];
}
