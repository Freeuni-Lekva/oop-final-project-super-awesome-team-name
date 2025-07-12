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
import java.util.Collections;
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

    // Friends search page
    @GetMapping("/search")
    public ModelAndView friendsSearch(@RequestParam(required = false) String query,
                                      @RequestParam(required = false) String error,
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

        if (query != null && !query.trim().isEmpty()) {
            try {
                // Simple search - check if exact username exists
                if (users.exists(query.trim())) {
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

        // Get pending friend requests
        try {
            List<FriendRequest> sentRequests = friendRequests.findSentBy(currentUser);
            List<String> pendingRequests = sentRequests.stream()
                    .map(FriendRequest::getRequesteeName)
                    .collect(Collectors.toList());
            mav.addObject("pendingRequests", pendingRequests);
        } catch (Exception e) {
            mav.addObject("pendingRequests", new ArrayList<String>());
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
}