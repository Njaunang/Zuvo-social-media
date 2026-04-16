# Zuvo Social Media Platform - Implementation Guide

## ✅ Completed Features

### 1. **Bottom Navigation Bar Navigation**
- **Location**: `lib/views/dashboard_page.dart`
- **Features**:
  - 5-tab navigation (Home, Search, Messages, Calls, Profile)
  - HugeIcons for all navigation items
  - Dynamic color change based on active tab
  - Theme-aware styling

### 2. **Like System** 
- **Location**: `lib/util/text_post.dart` & `lib/util/image_post.dart`
- **Features**:
  - Like button with heart icon (HugeIcons.strokeRoundedFavorite)
  - Real-time like counter increment/decrement
  - Visual feedback on liked state
  - Local state management for UI responsiveness
  - **Firestore Integration Ready**: Add `likes` array to posts collection to persist likes

### 3. **Chat/Messaging System**
- **Location**: `lib/views/messages/chat_page.dart`
- **Features**:
  - Real-time chat list from Firestore `chats` collection
  - One-on-one messaging interface
  - Message timestamps and formatting
  - Last message preview
  - Chat detail page with message history
  - Send button with loading state
  - Messages marked with sender ID for proper attribution

### 4. **Voice & Video Calls (ZegoCloud)**
- **Location**: `lib/views/calls/calls_page.dart`
- **Features**:
  - 3-tab interface (Voice, Video, Group)
  - User list from Firestore `users` collection
  - ZegoUIKitPrebuiltCall integration ready
  - Call quality optimized configuration
  - **TODO**: Add your ZegoCloud App ID and App Sign in `_startVoiceCall()` and `_startVideoCall()` methods

### 5. **User Profile Page**
- **Location**: `lib/views/profile/profile_page.dart`
- **Features**:
  - User avatar with initials
  - User stats (Posts, Followers, Following)
  - User's post history
  - Logout functionality
  - Follow/Follower counts from Firestore

### 6. **Post Display with Metadata**
- **Location**: `lib/util/text_post.dart` & `lib/util/image_post.dart`
- **Features**:
  - User information (username, email)
  - Like and comment counters
  - Smart timestamp formatting (now, 5m ago, 2h ago, etc.)
  - Beautiful card-based UI with shadows
  - Theme-aware colors (dark/light mode)
  - Image error handling

## 🔧 Firestore Database Structure

### Collections Required:

```
users/
├── {uid}/
│   ├── username (string)
│   ├── email (string)
│   ├── created_at (timestamp)
│   ├── followers (array)
│   ├── following (array)
│   └── follower_count (number)

posts/
├── {postId}/
│   ├── uid (string)
│   ├── username (string)
│   ├── email (string)
│   ├── content (string)
│   ├── type (string: 'text' or 'image')
│   ├── url (string - for images)
│   ├── time (timestamp)
│   ├── likes (number) 
│   ├── comments (number)
│   ├── likedBy (array - for persistent likes)
│   └── timeline_ids (array - which users' timelines include this)

chats/
├── {chatId}/
│   ├── participants (array: [uid1, uid2])
│   ├── lastMessage (string)
│   ├── lastMessageTime (timestamp)
│   └── messages/
│       └── {messageId}/
│           ├── senderId (string)
│           ├── senderName (string)
│           ├── text (string)
│           ├── timestamp (timestamp)
│           └── read (boolean)
```

## 🚀 Next Steps to Complete

### 1. **Image Upload Feature**
```dart
// Add to home_page.dart
Future<void> _uploadImage() async {
  final picker = ImagePicker();
  final image = await picker.pickImage(source: ImageSource.gallery);
  
  if (image != null) {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('posts/${user!.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');
    
    await storageRef.putFile(File(image.path));
    final url = await storageRef.getDownloadURL();
    
    await FirebaseFirestore.instance.collection('posts').add({
      'uid': user!.uid,
      'username': user!.displayName,
      'email': user!.email,
      'type': 'image',
      'url': url,
      'content': _captionController.text,
      'time': DateTime.now(),
      'likes': 0,
      'comments': 0,
    });
  }
}
```

### 2. **Persistent Like System** 
```dart
// Modify like button to persist to Firestore
Future<void> _toggleLike(String postId) async {
  final likesRef = FirebaseFirestore.instance
      .collection('posts')
      .doc(postId)
      .collection('likes');
  
  if (isLiked) {
    await likesRef.doc(user!.uid).delete();
  } else {
    await likesRef.doc(user!.uid).set({'uid': user!.uid});
  }
}
```

### 3. **Comment System**
```dart
// Create comment widget
streamBuilder(
  stream: FirebaseFirestore.instance
      .collection('posts')
      .doc(postId)
      .collection('comments')
      .orderBy('timestamp', descending: true)
      .snapshots(),
  // Build comment list
)
```

### 4. **ZegoCloud Setup**
1. Go to https://zegocloud.com/
2. Create project and get App ID & App Sign
3. Replace placeholders in `calls_page.dart`:
   ```dart
   const appID = YOUR_APP_ID;
   const appSign = 'YOUR_APP_SIGN';
   ```

### 5. **Follow/Unfollow Persistence**
Ensure timeline is updated when following:
```dart
Future<void> _followUser(String userId) async {
  final batch = FirebaseFirestore.instance.batch();
  
  // Update follower's following list
  batch.update(
    FirebaseFirestore.instance.collection('users').doc(user!.uid),
    {'following': FieldValue.arrayUnion([userId])},
  );
  
  // Add posts to timeline
  final postsSnapshot = await FirebaseFirestore.instance
      .collection('posts')
      .where('uid', isEqualTo: userId)
      .get();
  
  // Add each post to timeline...
}
```

## 📱 Localization Support

All strings are localized in:
- `lib/l10n/app_en.arb` (English)
- `lib/l10n/app_fr.arb` (French)

Run `flutter gen-l10n` after adding new strings.

## 🎨 Theme & Colors

Colors defined in `lib/constant/app_colors.dart`:
- Primary: `cyberRose` (#F64A8A)
- All components use Theme.of(context) for dark mode support

## ✨ Key Implementation Notes

1. **Timeline vs Posts**
   - `posts` collection = global social feed
   - `users/{uid}/timeline` = personalized feed (users you follow)
   - Currently showing all posts, ready to switch to timeline when needed

2. **Performance Optimization**
   - Using StreamBuilder for real-time updates
   - Lazy loading with ListView.builder
   - Null-safe operators throughout

3. **Error Handling**
   - Try-catch blocks for all Firestore operations
   - User-friendly error messages via ToastNotification
   - Image loading error handling with fallback

4. **State Management**
   - Provider for theme/locale
   - StatefulWidget for local UI state
   - Firestore Streams for data state

## 🔐 Firestore Security Rules (Updated)

```
match /databases/{database}/documents {
  match /users/{userId} {
    allow read: if true;
    allow create, update, delete: if request.auth.uid == userId;
    
    match /timeline/{postId} {
      allow read, write: if request.auth.uid == userId;
    }
  }
  
  match /posts/{postId} {
    allow read: if true;
    allow create: if request.auth != null;
    allow update, delete: if request.auth.uid == resource.data.uid;
    
    match /likes/{userId} {
      allow read: if true;
      allow write: if request.auth.uid == userId;
    }
    
    match /comments/{commentId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth.uid == resource.data.uid;
    }
  }
  
  match /chats/{chatId} {
    allow read, write: if request.auth.uid in resource.data.participants;
    
    match /messages/{messageId} {
      allow read, write: if request.auth.uid in get(/databases/$(database)/documents/chats/$(chatId)).data.participants;
    }
  }
}
```

## 📋 Remaining Tasks Checklist

- [ ] Implement persistent image upload
- [ ] Add comment system with UI
- [ ] Complete group call functionality
- [ ] Add push notifications
- [ ] Implement post editing/deletion
- [ ] Add user bio/profile customization
- [ ] Add block/report user features
- [ ] Implement activity/notification feed
- [ ] Add story feature
- [ ] Add reels/short video support

## 🐛 Known Issues & Solutions

**Issue**: ZegoCloud calls require proper SDK setup
**Solution**: Ensure `zego_uikit_prebuilt_call: ^4.22.4` is in pubspec.yaml and credentials are added

**Issue**: Timeline showing all posts instead of personalized feed
**Solution**: Change home_page.dart StreamBuilder to query user's timeline subcollection

**Issue**: Like counts not persisting after refresh
**Solution**: Store in `posts.likedBy` array field instead of just increment number

## 📞 Support
For issues with:
- **ZegoCloud**: https://zegocloud.com/docs
- **Firebase**: https://firebase.google.com/docs
- **Flutter**: https://flutter.dev/docs
