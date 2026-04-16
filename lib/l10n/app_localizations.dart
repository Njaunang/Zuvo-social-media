import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'Zuvo'**
  String get app_name;

  /// No description provided for @application_name.
  ///
  /// In en, this message translates to:
  /// **'Zuvo'**
  String get application_name;

  /// No description provided for @get_started.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get get_started;

  /// No description provided for @conditions_text.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to our'**
  String get conditions_text;

  /// No description provided for @term_of_service.
  ///
  /// In en, this message translates to:
  /// **'Term of Service '**
  String get term_of_service;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and '**
  String get and;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @welcome_text.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Zuvo! Create an account to get started and connect with others.'**
  String get welcome_text;

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! Please sign in to your account to continue connecting with friends and exploring the world of Zuvo.'**
  String get welcome_back;

  /// No description provided for @username_hintext.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username_hintext;

  /// No description provided for @password_hintext.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password_hintext;

  /// No description provided for @confirm_password_hintext.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password_hintext;

  /// No description provided for @email_hintext.
  ///
  /// In en, this message translates to:
  /// **'your@email.com'**
  String get email_hintext;

  /// No description provided for @signup_with_email.
  ///
  /// In en, this message translates to:
  /// **'Sign up with email'**
  String get signup_with_email;

  /// No description provided for @signin_with_email.
  ///
  /// In en, this message translates to:
  /// **'Sign in with email'**
  String get signin_with_email;

  /// No description provided for @or_text.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or_text;

  /// No description provided for @signin_link.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signin_link;

  /// No description provided for @signup_link.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signup_link;

  /// No description provided for @already_have_an_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get already_have_an_account;

  /// No description provided for @not_having_an_account.
  ///
  /// In en, this message translates to:
  /// **'Not having an account?'**
  String get not_having_an_account;

  /// No description provided for @signup_with_facebook.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Facebook'**
  String get signup_with_facebook;

  /// No description provided for @signin_with_facebook.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Facebook'**
  String get signin_with_facebook;

  /// No description provided for @success_title.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success_title;

  /// No description provided for @error_title.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error_title;

  /// No description provided for @sign_in_with_email_successfully.
  ///
  /// In en, this message translates to:
  /// **'Signed in successfully!'**
  String get sign_in_with_email_successfully;

  /// No description provided for @signout_successfully.
  ///
  /// In en, this message translates to:
  /// **' Logut successfully!'**
  String get signout_successfully;

  /// No description provided for @signup_with_email_successfully.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get signup_with_email_successfully;

  /// No description provided for @failed_signin_title.
  ///
  /// In en, this message translates to:
  /// **'Sign In Failed'**
  String get failed_signin_title;

  /// No description provided for @failed_signup_title.
  ///
  /// In en, this message translates to:
  /// **'Sign Up Failed'**
  String get failed_signup_title;

  /// No description provided for @signin_with_facebook_successfully.
  ///
  /// In en, this message translates to:
  /// **'Signed in with Facebook successfully!'**
  String get signin_with_facebook_successfully;

  /// No description provided for @signup_with_facebook_successfully.
  ///
  /// In en, this message translates to:
  /// **'Signed up with Facebook successfully!'**
  String get signup_with_facebook_successfully;

  /// No description provided for @facebook_signin_failed.
  ///
  /// In en, this message translates to:
  /// **'Facebook Sign In Failed'**
  String get facebook_signin_failed;

  /// No description provided for @facebook_signup_failed.
  ///
  /// In en, this message translates to:
  /// **'Facebook Sign Up Failed'**
  String get facebook_signup_failed;

  /// No description provided for @signup_with_email_password_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get signup_with_email_password_not_match;

  /// No description provided for @no_user_found.
  ///
  /// In en, this message translates to:
  /// **'No User Found!'**
  String get no_user_found;

  /// No description provided for @search_user.
  ///
  /// In en, this message translates to:
  /// **'Search for a user'**
  String get search_user;

  /// No description provided for @search_hintext.
  ///
  /// In en, this message translates to:
  /// **'Rechercher un utilisateur'**
  String get search_hintext;

  /// No description provided for @follow_button.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow_button;

  /// No description provided for @un_follow_button.
  ///
  /// In en, this message translates to:
  /// **'Unfollow'**
  String get un_follow_button;

  /// No description provided for @morining_greetings.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morining_greetings;

  /// No description provided for @evening_greetings.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening_greetings;

  /// No description provided for @afternoon_greetings.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get afternoon_greetings;

  /// No description provided for @post_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create post'**
  String get post_failed;

  /// No description provided for @post_successful.
  ///
  /// In en, this message translates to:
  /// **'Post created successfully!'**
  String get post_successful;

  /// No description provided for @empty_post_title.
  ///
  /// In en, this message translates to:
  /// **'Empty Post'**
  String get empty_post_title;

  /// No description provided for @empty_post_describtion.
  ///
  /// In en, this message translates to:
  /// **'Please write something to post!'**
  String get empty_post_describtion;

  /// No description provided for @post_hintext.
  ///
  /// In en, this message translates to:
  /// **'What\'s in your mind?'**
  String get post_hintext;

  /// No description provided for @post_button.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get post_button;

  /// No description provided for @anonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonyme'**
  String get anonymous;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @calls.
  ///
  /// In en, this message translates to:
  /// **'Calls'**
  String get calls;

  /// No description provided for @voice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get voice;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @group_call.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group_call;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @unknown_user.
  ///
  /// In en, this message translates to:
  /// **'Unknown User'**
  String get unknown_user;

  /// No description provided for @no_email.
  ///
  /// In en, this message translates to:
  /// **'No email'**
  String get no_email;

  /// No description provided for @my_posts.
  ///
  /// In en, this message translates to:
  /// **'My Posts'**
  String get my_posts;

  /// No description provided for @no_messages_yet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get no_messages_yet;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @type_message_hintext.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get type_message_hintext;

  /// No description provided for @no_post_yet.
  ///
  /// In en, this message translates to:
  /// **'No posts yet. Be the first to post!'**
  String get no_post_yet;

  /// No description provided for @no_users_available.
  ///
  /// In en, this message translates to:
  /// **'No users available'**
  String get no_users_available;

  /// No description provided for @select_a_contact_to_start_a_voice_call.
  ///
  /// In en, this message translates to:
  /// **'Select a contact to start a voice call'**
  String get select_a_contact_to_start_a_voice_call;

  /// No description provided for @start_a_group_call.
  ///
  /// In en, this message translates to:
  /// **'Start a group call'**
  String get start_a_group_call;

  /// No description provided for @create_group_call.
  ///
  /// In en, this message translates to:
  /// **'Create Group Call'**
  String get create_group_call;

  /// No description provided for @no_conversations_yet.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get no_conversations_yet;

  /// No description provided for @no_posted_yet.
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get no_posted_yet;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @no_comments_yet.
  ///
  /// In en, this message translates to:
  /// **'No comments yet'**
  String get no_comments_yet;

  /// No description provided for @add_a_comment_hintext.
  ///
  /// In en, this message translates to:
  /// **'Add a comment...'**
  String get add_a_comment_hintext;

  /// No description provided for @followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followers;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @group_call_come_soon.
  ///
  /// In en, this message translates to:
  /// **'Group call feature coming soon!'**
  String get group_call_come_soon;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
