package ge.edu.freeuni.controller;

import ge.edu.freeuni.dao.*;
import ge.edu.freeuni.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/friends")
public class FriendsController {

    @Autowired
    private UserDao users;

    @Autowired
    private FriendshipDao friendships;

    @Autowired
    private FriendRequestDao friendRequests;

    @Autowired
    private MessageDao messages;

    // Friends search page
    @GetMapping("/search")
    public ModelAndView friendsSearch(@RequestParam(required = false) String query,
                                      @RequestParam(required = false) String error,
                                      @RequestParam(required = false) String success,
                                      HttpSession session) {
        String currentUser = (String) session.getAttribute("name");
        if (currentUser == null) {
            return new ModelAndView("redirect:/welcome");
        }

        ModelAndView mav = new ModelAndView("friends/search");
        mav.addObject("currentUser", currentUser);

        if (error != null) {
            mav.addObject("error", error);
        }

        if (success != null) {
            mav.addObject("success", success);
        }

        if (query != null && !query.trim().isEmpty()) {
            try {
                // Simple search - check if exact username exists
                if (users.exists(query.trim()) && !query.trim().equals(currentUser)) {
                    mav.addObject("searchResults", Arrays.asList(query.trim()));
                    mav.addObject("query", query.trim());
                } else {
                    mav.addObject("searchResults", new ArrayList<String>());
                    mav.addObject("query", query.trim());
                    mav.addObject("noResults", true);
                }
            } catch (Exception e) {
                mav.addObject("error", "Error searching for users: " + e.getMessage());
            }
        }

        // Get user's current friends
        try {
            List<Friendship> userFriends = friendships.findByUser(currentUser);
            List<String> friendNames = userFriends.stream()
                    .map(Friendship::getFriendName)
                    .collect(Collectors.toList());
            mav.addObject("currentFriends", friendNames);
        } catch (Exception e) {
            mav.addObject("currentFriends", new ArrayList<String>());
        }

        // Get pending friend requests (sent)
        try {
            List<FriendRequest> sentRequests = friendRequests.findSentBy(currentUser);
            List<String> pendingRequests = sentRequests.stream()
                    .map(FriendRequest::getRequesteeName)
                    .collect(Collectors.toList());
            mav.addObject("pendingRequests", pendingRequests);
        } catch (Exception e) {
            mav.addObject("pendingRequests", new ArrayList<String>());
        }

        // Get received friend requests
        try {
            List<FriendRequest> receivedRequests = friendRequests.findPendingFor(currentUser);
            List<String> receivedRequestNames = receivedRequests.stream()
                    .map(FriendRequest::getRequesterName)
                    .collect(Collectors.toList());
            mav.addObject("receivedRequests", receivedRequestNames);
        } catch (Exception e) {
            mav.addObject("receivedRequests", new ArrayList<String>());
        }

        return mav;
    }

    // My friends list page
    @GetMapping("/list")
    public ModelAndView friendsList(HttpSession session) {
        String currentUser = (String) session.getAttribute("name");
        if (currentUser == null) {
            return new ModelAndView("redirect:/welcome");
        }

        ModelAndView mav = new ModelAndView("friends/list");
        mav.addObject("currentUser", currentUser);

        try {
            // Get user's friends
            List<Friendship> userFriends = friendships.findByUser(currentUser);
            mav.addObject("friends", userFriends);

            // Get sent requests
            List<FriendRequest> sentRequests = friendRequests.findSentBy(currentUser);
            mav.addObject("sentRequests", sentRequests);

            // Get received requests
            List<FriendRequest> receivedRequests = friendRequests.findPendingFor(currentUser);
            mav.addObject("receivedRequests", receivedRequests);

        } catch (Exception e) {
            mav.addObject("error", "Error loading friends list: " + e.getMessage());
            mav.addObject("friends", new ArrayList<Friendship>());
            mav.addObject("sentRequests", new ArrayList<FriendRequest>());
            mav.addObject("receivedRequests", new ArrayList<FriendRequest>());
        }

        return mav;
    }

    // Send friend request
    @PostMapping("/add")
    public ModelAndView sendFriendRequest(@RequestParam String friendName, HttpSession session) {
        String currentUser = (String) session.getAttribute("name");
        if (currentUser == null) {
            return new ModelAndView("redirect:/welcome");
        }

        try {
            // Check if user exists
            if (!users.exists(friendName)) {
                return new ModelAndView("redirect:/friends/search?error=User '" + friendName + "' not found");
            }

            // Check if trying to add themselves
            if (currentUser.equals(friendName)) {
                return new ModelAndView("redirect:/friends/search?error=You cannot add yourself as a friend");
            }

            // Check if already friends
            List<Friendship> currentFriends = friendships.findByUser(currentUser);
            boolean alreadyFriends = currentFriends.stream()
                    .anyMatch(f -> f.getFriendName().equals(friendName));

            if (alreadyFriends) {
                return new ModelAndView("redirect:/friends/search?error=You are already friends with " + friendName);
            }

            // Check if friend request already sent
            List<FriendRequest> sentRequests = friendRequests.findSentBy(currentUser);
            boolean requestAlreadySent = sentRequests.stream()
                    .anyMatch(r -> r.getRequesteeName().equals(friendName));

            if (requestAlreadySent) {
                return new ModelAndView("redirect:/friends/search?error=Friend request already sent to " + friendName);
            }

            // Check if they already sent us a request
            List<FriendRequest> receivedRequests = friendRequests.findPendingFor(currentUser);
            boolean receivedRequestExists = receivedRequests.stream()
                    .anyMatch(r -> r.getRequesterName().equals(friendName));

            if (receivedRequestExists) {
                return new ModelAndView("redirect:/friends/search?error=" + friendName + " has already sent you a friend request. Check your messages to accept it.");
            }

            // Create friend request in database
            boolean requestCreated = friendRequests.insertRequest(currentUser, friendName);

            if (requestCreated) {
                // Get the created request to send message
                List<FriendRequest> newSentRequests = friendRequests.findSentBy(currentUser);
                FriendRequest newRequest = newSentRequests.stream()
                        .filter(r -> r.getRequesteeName().equals(friendName))
                        .findFirst().orElse(null);

                if (newRequest != null) {
                    // Send friend request message
                    messages.sendFriendRequest(currentUser, friendName, newRequest.getId());
                }

                return new ModelAndView("redirect:/friends/search?success=Friend request sent to " + friendName + "! They will receive a message to accept or decline.");
            } else {
                return new ModelAndView("redirect:/friends/search?error=Failed to send friend request. Please try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            return new ModelAndView("redirect:/friends/search?error=Error sending friend request: " + e.getMessage());
        }
    }

    // Remove friend
    @PostMapping("/remove")
    public ModelAndView removeFriend(@RequestParam String friendName, HttpSession session) {
        String currentUser = (String) session.getAttribute("name");
        if (currentUser == null) {
            return new ModelAndView("redirect:/welcome");
        }

        try {
            // Remove friendship (bidirectional)
            friendships.deleteFriendship(currentUser, friendName);
            friendships.deleteFriendship(friendName, currentUser);

            return new ModelAndView("redirect:/friends/list?success=Removed " + friendName + " from your friends list");

        } catch (Exception e) {
            e.printStackTrace();
            return new ModelAndView("redirect:/friends/list?error=Failed to remove friend: " + e.getMessage());
        }
    }

    // Cancel friend request
    @PostMapping("/cancel")
    public ModelAndView cancelFriendRequest(@RequestParam String friendName, HttpSession session) {
        String currentUser = (String) session.getAttribute("name");
        if (currentUser == null) {
            return new ModelAndView("redirect:/welcome");
        }

        try {
            // Find and update the friend request
            List<FriendRequest> sentRequests = friendRequests.findSentBy(currentUser);
            FriendRequest requestToCancel = sentRequests.stream()
                    .filter(r -> r.getRequesteeName().equals(friendName))
                    .findFirst().orElse(null);

            if (requestToCancel != null) {
                friendRequests.updateStatus(requestToCancel.getId(), "CANCELLED");
                return new ModelAndView("redirect:/friends/search?success=Friend request to " + friendName + " has been cancelled");
            } else {
                return new ModelAndView("redirect:/friends/search?error=No pending friend request found for " + friendName);
            }

        } catch (Exception e) {
            e.printStackTrace();
            return new ModelAndView("redirect:/friends/search?error=Failed to cancel friend request: " + e.getMessage());
        }
    }
}