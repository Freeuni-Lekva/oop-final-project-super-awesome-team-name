package Quiz_Engine_Tests;

import Quiz_Engine.Question.*;
import Quiz_Engine.Quiz;
import org.junit.jupiter.api.Test;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;

public class Quiz_Test {

    @Test
    public void testInitialState() {
        Quiz quiz = new Quiz();
        assertNull(quiz.getQuizzName());
        assertNull(quiz.getDescription());
        assertFalse(quiz.isRandomOrder());
        assertFalse(quiz.isOnePage());
        assertFalse(quiz.isImmediateCorrection());
        assertFalse(quiz.isPracticeMode());
        assertNull(quiz.getCreatorUsername());
        assertEquals(0, quiz.getQuizzID());
        assertNull(quiz.getQuestions());
    }

    @Test
    public void testSettersAndGetters() {
        Quiz quiz = new Quiz();
        quiz.setQuizzID(42);
        quiz.setQuizzName("Science Quiz");
        quiz.setDescription("A quiz about science.");
        quiz.setRandomOrder(true);
        quiz.setOnePage(true);
        quiz.setImmediateCorrection(true);
        quiz.setPracticeMode(true);
        quiz.setCreatorUsername("adminUser");

        assertEquals(42, quiz.getQuizzID());
        assertEquals("Science Quiz", quiz.getQuizzName());
        assertEquals("A quiz about science.", quiz.getDescription());
        assertTrue(quiz.isRandomOrder());
        assertTrue(quiz.isOnePage());
        assertTrue(quiz.isImmediateCorrection());
        assertTrue(quiz.isPracticeMode());
        assertEquals("adminUser", quiz.getCreatorUsername());
    }

    @Test
    public void testSetAndGetQuestions_AllTypes() {
        Quiz quiz = new Quiz();
        List<Question> questions = new ArrayList<>();

        questions.add(new Question_Response("What is 2 + 2?", "Question-Response", "4"));
        questions.add(new Fill_In_The_Blank("The capital of France is _.", "Fill in the Blank", "Paris"));
        questions.add(new Multiple_Choice("Largest planet?", "Multiple Choice",
                Arrays.asList("Mars", "Earth", "Jupiter"),"Jupiter"));
        questions.add(new Picture_Response("Identify this landmark", "Picture-Response",
                "Eiffel Tower", "http://example.com/image.jpg"));
        questions.add(new Multi_Answer("Name primary colors", "Multi-Answer",false,
                Arrays.asList("red", "blue", "yellow")));
        questions.add(new Multi_Choice_Multi_Answer("Pick fruits", "Multiple Choice with Multiple Answers",
                Arrays.asList("Apple", "Car", "Banana"), Arrays.asList("Apple", "Banana")));

        Map<String, String> matchPairs = new HashMap<>();
        matchPairs.put("Cat", "Meow");
        matchPairs.put("Dog", "Bark");
        questions.add(new Matching("Match animals to sounds", "Matching", matchPairs));

        quiz.setQuestions(questions);

        List<Question> stored = quiz.getQuestions();
        assertEquals(7, stored.size());
        assertTrue(stored.get(0) instanceof Question_Response);
        assertTrue(stored.get(1) instanceof Fill_In_The_Blank);
        assertTrue(stored.get(2) instanceof Multiple_Choice);
        assertTrue(stored.get(3) instanceof Picture_Response);
        assertTrue(stored.get(4) instanceof Multi_Answer);
        assertTrue(stored.get(5) instanceof Multi_Choice_Multi_Answer);
        assertTrue(stored.get(6) instanceof Matching);
    }

    @Test
    public void testSetEmptyQuestions() {
        Quiz quiz = new Quiz();
        List<Question> emptyList = new ArrayList<>();
        quiz.setQuestions(emptyList);
        assertNotNull(quiz.getQuestions());
        assertEquals(0, quiz.getQuestions().size());
    }

    @Test
    public void testNullQuestionsDefaultsToEmptyList() {
        Quiz quiz = new Quiz();
        quiz.setQuestions(null);
        assertNull(quiz.getQuestions());
    }
}
