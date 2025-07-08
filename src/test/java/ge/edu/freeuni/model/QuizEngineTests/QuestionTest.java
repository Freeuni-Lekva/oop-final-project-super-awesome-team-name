package ge.edu.freeuni.model.QuizEngineTests;

import ge.edu.freeuni.model.QuizEngine.Question.*;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

public class QuestionTest {

    @Test
    public void testQuestionResponse() {
        Question q = new Question_Response("What is 2+2?", "Question-Response","4");
        assertEquals("What is 2+2?", q.getQuestion());
        assertTrue(q.isCorrect("4"));
        assertEquals("4", q.getCorrectAnswer());
        assertFalse(q.isCorrect("5"));
    }

    @Test
    public void testFillInTheBlank() {
        Question q = new Fill_In_The_Blank("The capital of France is _.", "Fill in the Blank","Paris");
        assertEquals("The capital of France is _.", q.getQuestion());
        assertTrue(q.isCorrect("paris"));
        assertEquals("Paris", q.getCorrectAnswer());
        assertFalse(q.isCorrect("Lyon"));
    }

    @Test
    public void testMultipleChoice() {
        List<String> options = Arrays.asList("Red", "Green", "Blue");
        Question q = new Multiple_Choice("Pick a color","Multiple Choice" ,options,"Blue");
        assertEquals("Pick a color", q.getQuestion());
        assertTrue(q.isCorrect("Blue"));
        assertFalse(q.isCorrect("Red"));
    }

    @Test
    public void testPictureResponse() {
        Question q = new Picture_Response("Name the Animal","Picture-Response","https://example.com/cat.jpg","cat");
        assertEquals("https://example.com/cat.jpg", ((Picture_Response) q).getImageURL());
        assertTrue(q.isCorrect("cat"));
        assertEquals("cat", q.getCorrectAnswer());
        assertFalse(q.isCorrect("dog"));
    }

    @Test
    public void testMultiAnswerOrderMattersFalse() {
        List<String> answers = Arrays.asList("apple", "banana", "cherry");
        Question q = new Multi_Answer("Name 3 fruits", "Multi-Answer", false,answers);

        assertTrue(q.isCorrect("banana,apple,cherry"));
        assertEquals(answers, q.getCorrectAnswer());
        assertFalse(q.isCorrect("banana,apple"));
        assertFalse(q.isCorrect("banana,apple,grape"));
    }

    @Test
    public void testMultiAnswerOrderMattersTrue() {
        List<String> answers = Arrays.asList("one", "two", "three");
        Question q = new Multi_Answer("Count to three", "Multi-Answer", true,answers);

        assertTrue(q.isCorrect("one,two,three"));
        assertEquals(answers, q.getCorrectAnswer());
        assertFalse(q.isCorrect("three,two,one"));
    }

    @Test
    public void testMCWithMultipleAnswers() {
        List<String> correct = Arrays.asList("1", "3");
        List<String> incorrect = Arrays.asList("2", "4");
        Question q = new Multi_Choice_Multi_Answer("Pick odd numbers", "Multiple Choice with Multiple Answers",correct, incorrect);

        assertTrue(q.isCorrect("1,3"));
        assertEquals(correct, q.getCorrectAnswer());
        assertFalse(q.isCorrect("1,2"));
        assertFalse(q.isCorrect("2,4"));
    }

    @Test
    public void testMatching() {
        HashMap<String, String> pairs = new HashMap<>();
        pairs.put("dog", "bark");
        pairs.put("cat", "meow");

        Question q = new Matching("Match animals to sounds", "Matching",pairs);

        assertTrue(q.isCorrect("dog=bark;cat=meow"));
        assertFalse(q.isCorrect("cat=bark;dog=meow"));

    }

    @Test
    public void testToString() {
        Question q = new Question_Response("How are you?","Question-Response" ,"Fine");
        assertTrue(q.toString().contains("How are you?"));
    }
}
