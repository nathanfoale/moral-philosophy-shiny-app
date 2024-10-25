# Load necessary libraries
library(shiny)
library(shinyWidgets)
library(shinythemes)
library(shinyjs)
library(shinyBS)
library(plotly)
library(dplyr)
library(rsconnect)

# Define the metaethical positions and their subcategories
metaethical_positions <- c(
  "Moral Realism", "Moral Anti-Realism", "Cognitivism", "Non-Cognitivism",
  "Moral Objectivism", "Moral Relativism",
  "Moral Nihilism", "Moral Skepticism", "Constructivism",
  "Postmodern Ethics", "Moral Particularism", "Moral Pluralism",
  "Existentialist Ethics"
)

metaethical_subcategories <- list(
  "Moral Realism" = c("Moral Realism"),
  "Moral Objectivism" = c("Moral Objectivism"),
  "Cognitivism" = c("Cognitivism"),
  "Non-Cognitivism" = c("Non-Cognitivism"),
  "Constructivism" = c("Constructivism"),
  "Postmodern Ethics" = c("Postmodern Ethics"),
  "Anti-Realism" = c("Moral Anti-Realism", "Moral Relativism", "Moral Nihilism"),
  "Moral Skepticism" = c("Moral Skepticism"),
  "Particularism" = c("Moral Particularism", "Moral Pluralism"),
  "Existentialism" = c("Existentialist Ethics")
)

# Define the normative philosophies and their subcategories
normative_philosophies <- c(
  "Act Utilitarianism", "Rule Utilitarianism", "Utilitarianism",
  "Kantian Deontology", "Rule Deontology", "Deontology",
  "Classical Virtue Ethics", "Mixed Virtue Ethics", "Virtue Ethics",
  "Care Ethics", "Ethical Egoism", "Altruism", "Divine Command Theory",
  "Feminist/Gender Theory Ethics", "Environmental Ethics", "Pragmatism",
  "Emotivism", "Libertarianism", "Hedonism", "Contractualism",
  "Moral Minimalism"
)

normative_subcategories <- list(
  "Utilitarianism" = c("Act Utilitarianism", "Rule Utilitarianism", "Utilitarianism"),
  "Deontology" = c("Kantian Deontology", "Rule Deontology", "Deontology"),
  "Virtue Ethics" = c("Classical Virtue Ethics", "Mixed Virtue Ethics", "Virtue Ethics"),
  "Ethics of Care" = c("Care Ethics"),
  "Gender Theory Ethics" = c("Feminist/Gender Theory Ethics"),
  "Egoism" = c("Ethical Egoism"),
  "Libertarianism" = c("Libertarianism"),
  "Altruism" = c("Altruism", "Environmental Ethics"),
  "Religious Ethics" = c("Divine Command Theory"),
  "Emotivism" = c("Emotivism"),
  "Pragmatism" = c("Pragmatism"),
  "Hedonism" = c("Hedonism"),
  "Contractualism" = c("Contractualism")
)

# Define contradictions between metaethical positions
contradictions <- list(
  "Moral Realism" = c("Moral Anti-Realism", "Constructivism", "Postmodern Ethics"),
  "Moral Anti-Realism" = c("Moral Realism"),
  "Cognitivism" = c("Non-Cognitivism"),
  "Non-Cognitivism" = c("Cognitivism"),
  "Moral Objectivism" = c("Moral Relativism", "Moral Nihilism", "Constructivism", "Postmodern Ethics"),
  "Moral Relativism" = c("Moral Objectivism"),
  "Moral Nihilism" = c("Moral Objectivism", "Moral Pluralism", "Constructivism"),
  "Constructivism" = c("Moral Realism", "Moral Objectivism", "Moral Nihilism"),
  "Postmodern Ethics" = c("Moral Objectivism", "Moral Realism"),
  "Moral Pluralism" = c("Moral Nihilism"),
  "Existentialist Ethics" = c("Divine Command Theory", "Rule-Based Deontology"),
  "Contractualism" = c("Ethical Egoism", "Moral Nihilism"),
  "Moral Minimalism" = c("Altruism", "Deontological Ethics")
)

# Logical Contradictions (Mutually Exclusive Positions)
logical_contradictions <- list(
  # Metaethical Positions
  "Moral Realism" = c("Moral Anti-Realism"),
  "Moral Anti-Realism" = c("Moral Realism"),
  "Cognitivism" = c("Non-Cognitivism"),
  "Non-Cognitivism" = c("Cognitivism"),
  "Moral Objectivism" = c("Moral Relativism", "Moral Nihilism"),
  "Moral Relativism" = c("Moral Objectivism"),
  "Moral Nihilism" = c("Moral Realism", "Moral Objectivism"),
  "Moral Skepticism" = c(),
  "Constructivism" = c("Moral Realism"),
  "Postmodern Ethics" = c("Moral Realism", "Moral Objectivism"),
  "Existentialist Ethics" = c("Divine Command Theory"),
  "Divine Command Theory" = c("Existentialist Ethics"),
  "Rule-Based Deontology" = c("Moral Particularism"),
  "Moral Particularism" = c("Rule-Based Deontology"),
  "Ethical Egoism" = c("Altruism"),
  "Altruism" = c("Ethical Egoism"),
  # Normative Philosophies
  "Act Utilitarianism" = c("Kantian Deontology"),
  "Kantian Deontology" = c("Act Utilitarianism"),
  "Hedonism" = c("Virtue Ethics"),
  "Virtue Ethics" = c("Hedonism"),
  "Libertarianism" = c("Care Ethics"),
  "Care Ethics" = c("Libertarianism"),
  "Environmental Ethics" = c("Ethical Egoism"),
  "Feminist/Gender Theory Ethics" = c("Libertarianism")
)

# Conceptual Contradictions (Inconsistent Beliefs)
conceptual_contradictions <- list(
  # Metaethical Positions
  "Moral Realism" = c("Constructivism", "Postmodern Ethics"),
  "Moral Objectivism" = c("Constructivism", "Postmodern Ethics"),
  "Constructivism" = c("Moral Objectivism", "Moral Nihilism"),
  "Postmodern Ethics" = c(),
  "Moral Nihilism" = c("Constructivism", "Moral Pluralism"),
  "Moral Skepticism" = c("Moral Objectivism"),
  "Moral Pluralism" = c("Moral Nihilism"),
  "Existentialist Ethics" = c("Rule-Based Deontology"),
  "Contractualism" = c("Ethical Egoism", "Moral Nihilism"),
  "Moral Minimalism" = c("Altruism", "Deontological Ethics"),
  # Normative Philosophies
  "Act Utilitarianism" = c("Rule Deontology", "Virtue Ethics"),
  "Rule Utilitarianism" = c("Kantian Deontology"),
  "Kantian Deontology" = c("Act Utilitarianism", "Pragmatism"),
  "Pragmatism" = c("Kantian Deontology", "Divine Command Theory"),
  "Virtue Ethics" = c("Hedonism", "Emotivism"),
  "Emotivism" = c("Virtue Ethics"),
  "Care Ethics" = c("Libertarianism"),
  "Libertarianism" = c("Care Ethics", "Feminist/Gender Theory Ethics"),
  "Environmental Ethics" = c("Ethical Egoism", "Libertarianism"),
  "Ethical Egoism" = c("Environmental Ethics", "Contractualism"),
  "Altruism" = c("Ethical Egoism", "Moral Minimalism"),
  "Divine Command Theory" = c("Existentialist Ethics", "Pragmatism")
)

# Define the questions with adjusted answers
questions <- list(
  list(
    question = "Do you believe that perspectives from all cultures, including those with differing worldviews like the Taliban, can offer valuable insights into fields like physics?",
    answers = list(
      "Strongly Agree" = c("Moral Relativism" = 5, "Constructivism" = 3, "Moral Pluralism" = 2),
      "Agree" = c("Moral Relativism" = 3, "Constructivism" = 2, "Moral Pluralism" = 1),
      "Neutral" = c(),
      "Disagree" = c("Moral Objectivism" = 3, "Moral Realism" = 2),
      "Strongly Disagree" = c("Moral Objectivism" = 5, "Moral Realism" = 3)
    ),
    followup = list(
      question = "Should scientific inquiry remain open to all perspectives, regardless of their origin, to foster a more comprehensive understanding of the world?",
      answers = list(
        "Strongly Agree" = c("Moral Pluralism" = 5, "Pragmatism" = 3, "Constructivism" = 2),
        "Agree" = c("Moral Pluralism" = 3, "Pragmatism" = 2, "Constructivism" = 1),
        "Neutral" = c(),
        "Disagree" = c("Moral Realism" = 3, "Moral Objectivism" = 2),
        "Strongly Disagree" = c("Moral Realism" = 5, "Moral Objectivism" = 3)
      )
    )
  ),
  list(
    question = "In a society where everyone believes that a harmful practice is acceptable, is it still wrong?",
    answers = list(
      "Yes, it's still wrong." = c("Moral Realism" = 5, "Moral Objectivism" = 5),
      "Probably, but context matters." = c("Moral Realism" = 3, "Moral Objectivism" = 3),
      "Not sure." = c(),
      "No, morality is defined by society." = c("Moral Relativism" = 3, "Constructivism" = 2),
      "Definitely not; right and wrong are societal constructs." = c("Moral Relativism" = 5, "Constructivism" = 4)
    ),
    followup = list(
      question = "Do you believe that moral facts exist independently of human beliefs or perceptions?",
      answers = list(
        "Strongly Agree" = c("Moral Realism" = 5, "Moral Objectivism" = 5),
        "Agree" = c("Moral Realism" = 3, "Moral Objectivism" = 3),
        "Neutral" = c(),
        "Disagree" = c("Moral Relativism" = 3, "Moral Anti-Realism" = 2),
        "Strongly Disagree" = c("Moral Relativism" = 5, "Moral Anti-Realism" = 4)
      )
    )
  ),
  
  # Question 2: Cognitivism vs. Non-Cognitivism
  list(
    question = "When someone says 'It's wrong to lie,' are they stating a fact or expressing a personal feeling?",
    answers = list(
      "Stating a fact." = c("Cognitivism" = 5),
      "Mostly a fact." = c("Cognitivism" = 3),
      "Not sure." = c(),
      "Expressing a personal feeling." = c("Non-Cognitivism" = 3),
      "Definitely expressing a personal feeling." = c("Non-Cognitivism" = 5)
    ),
    followup = list(
      question = "Are moral claims expressions of emotions or commands rather than factual statements?",
      answers = list(
        "Strongly Agree" = c("Non-Cognitivism" = 5),
        "Agree" = c("Non-Cognitivism" = 3),
        "Neutral" = c(),
        "Disagree" = c("Cognitivism" = 3),
        "Strongly Disagree" = c("Cognitivism" = 5)
      )
    )
  ),
  
  # Question 3: Moral Objectivism vs. Moral Relativism
  list(
    question = "There are universal moral truths that apply to everyone, regardless of culture or context.",
    answers = list(
      "Strongly Agree" = c("Moral Objectivism" = 5, "Kantian Deontology" = 4),
      "Agree" = c("Moral Objectivism" = 3, "Kantian Deontology" = 2),
      "Neutral" = c(),
      "Disagree" = c("Moral Relativism" = 3, "Utilitarianism" = 2),
      "Strongly Disagree" = c("Moral Relativism" = 5, "Utilitarianism" = 3)
    ),
    followup = list(
      question = "Do you think that moral laws are inherent in human nature and can be discovered through reason?",
      answers = list(
        "Strongly Agree" = c("Kantian Deontology" = 5, "Moral Objectivism" = 5),
        "Agree" = c("Kantian Deontology" = 3, "Moral Objectivism" = 3),
        "Neutral" = c(),
        "Disagree" = c("Moral Relativism" = 3, "Constructivism" = 2),
        "Strongly Disagree" = c("Moral Relativism" = 5, "Constructivism" = 4)
      )
    )
  ),
  
  # Question 4: Moral Relativism vs. Moral Absolutism
  list(
    question = "What is morally right or wrong depends on cultural or societal norms.",
    answers = list(
      "Strongly Agree" = c("Moral Relativism" = 5, "Constructivism" = 3),
      "Agree" = c("Moral Relativism" = 3, "Constructivism" = 2),
      "Neutral" = c(),
      "Disagree" = c("Moral Objectivism" = 2),
      "Strongly Disagree" = c("Moral Objectivism" = 4)
    ),
    followup = list(
      question = "Do you believe that moral values are shaped entirely by cultural traditions and societal influences?",
      answers = list(
        "Strongly Agree" = c("Moral Relativism" = 5, "Constructivism" = 3),
        "Agree" = c("Moral Relativism" = 3, "Constructivism" = 2),
        "Neutral" = c(),
        "Disagree" = c("Moral Objectivism" = 2),
        "Strongly Disagree" = c("Moral Objectivism" = 4)
      )
    )
  ),
  
  # Question 5: Emotivism
  list(
    question = "Do you believe that ethical statements like 'Stealing is wrong' are merely expressions of emotional reactions rather than factual claims?",
    answers = list(
      "Strongly Agree" = c("Emotivism" = 5),
      "Agree" = c("Emotivism" = 3),
      "Neutral" = c(),
      "Disagree" = c("Cognitivism" = 3),
      "Strongly Disagree" = c("Cognitivism" = 5)
    ),
    followup = list(
      question = "Are moral statements expressions of emotional reactions rather than factual claims?",
      answers = list(
        "Strongly Agree" = c("Emotivism" = 5),
        "Agree" = c("Emotivism" = 3),
        "Neutral" = c(),
        "Disagree" = c("Cognitivism" = 3),
        "Strongly Disagree" = c("Cognitivism" = 5)
      )
    )
  ),
  
  # Question 6: Moral Skepticism
  list(
    question = "Does the variability of moral codes across cultures indicate that moral truths are unknowable?",
    answers = list(
      "Strongly Agree" = c("Moral Skepticism" = 5, "Moral Relativism" = 3),
      "Agree" = c("Moral Skepticism" = 3, "Moral Relativism" = 2),
      "Neutral" = c(),
      "Disagree" = c("Moral Objectivism" = 2),
      "Strongly Disagree" = c("Moral Objectivism" = 4)
    ),
    followup = list(
      question = "Does cultural diversity in moral practices suggest that there are no universal moral truths?",
      answers = list(
        "Strongly Agree" = c("Moral Relativism" = 5, "Moral Skepticism" = 3),
        "Agree" = c("Moral Relativism" = 3, "Moral Skepticism" = 2),
        "Neutral" = c(),
        "Disagree" = c("Moral Objectivism" = 3),
        "Strongly Disagree" = c("Moral Objectivism" = 5)
      )
    )
  ),
  
  # Question 7: Moral Skepticism and Moral Nihilism
  list(
    question = "We cannot know with certainty what is morally right or wrong.",
    answers = list(
      "Strongly Agree" = c("Moral Skepticism" = 5, "Moral Nihilism" = 3),
      "Agree" = c("Moral Skepticism" = 3),
      "Neutral" = c(),
      "Disagree" = c("Moral Objectivism" = 2),
      "Strongly Disagree" = c("Moral Objectivism" = 4)
    ),
    followup = list(
      question = "Is moral 'knowledge' subjective and open to individual interpretation?",
      answers = list(
        "Strongly Agree" = c("Moral Skepticism" = 5, "Moral Nihilism" = 1),
        "Agree" = c("Moral Skepticism" = 3),
        "Neutral" = c(),
        "Disagree" = c("Moral Objectivism" = 2),
        "Strongly Disagree" = c("Moral Objectivism" = 4)
      )
    )
  ),
  
  # Question 8: Constructivism
  list(
    question = "Are moral truths constructed by societies or individuals rather than existing objectively?",
    answers = list(
      "Strongly Agree" = c("Constructivism" = 5, "Postmodern Ethics" = 3),
      "Agree" = c("Constructivism" = 3, "Postmodern Ethics" = 2),
      "Neutral" = c(),
      "Disagree" = c("Moral Realism" = 3, "Moral Objectivism" = 2),
      "Strongly Disagree" = c("Moral Realism" = 5, "Moral Objectivism" = 4)
    ),
    followup = list(
      question = "Do you believe that rational agents create moral principles through agreements or social practices?",
      answers = list(
        "Strongly Agree" = c("Constructivism" = 5, "Contractualism" = 3),
        "Agree" = c("Constructivism" = 3, "Contractualism" = 2),
        "Neutral" = c(),
        "Disagree" = c("Moral Realism" = 3),
        "Strongly Disagree" = c("Moral Realism" = 5)
      )
    )
  ),
  
  # Question 9: Moral Skepticism (Revisited)
  list(
    question = "Do you believe that our understanding of morality is always subject to doubt and revision?",
    answers = list(
      "Strongly Agree" = c("Moral Skepticism" = 2),
      "Agree" = c("Moral Skepticism" = 1),
      "Neutral" = c(),
      "Disagree" = c("Moral Realism" = 3),
      "Strongly Disagree" = c("Moral Realism" = 5)
    ),
    followup = list(
      question = "Is it possible that some moral principles could remain universally true despite evolving perspectives?",
      answers = list(
        "Strongly Agree" = c("Moral Realism" = 5),
        "Agree" = c("Moral Realism" = 3),
        "Neutral" = c(),
        "Disagree" = c("Moral Skepticism" = 3),
        "Strongly Disagree" = c("Moral Skepticism" = 5)
      )
    )
  ),
  
  # Question 10: Moral Particularism
  list(
    question = "Should moral judgments be made on a case-by-case basis without relying on universal principles?",
    answers = list(
      "Strongly Agree" = c("Moral Particularism" = 5, "Moral Pluralism" = 3),
      "Agree" = c("Moral Particularism" = 3, "Moral Pluralism" = 2),
      "Neutral" = c(),
      "Disagree" = c("Rule-Based Deontology" = 2),
      "Strongly Disagree" = c("Rule-Based Deontology" = 4)
    ),
    followup = list(
      question = "Do you think that context and specific details are more important than general moral rules?",
      answers = list(
        "Strongly Agree" = c("Moral Particularism" = 5, "Virtue Ethics" = 3),
        "Agree" = c("Moral Particularism" = 3, "Virtue Ethics" = 2),
        "Neutral" = c(),
        "Disagree" = c("Rule-Based Deontology" = 3),
        "Strongly Disagree" = c("Rule-Based Deontology" = 5)
      )
    )
  ),
  
  # Question 11: Moral Pluralism
  list(
    question = "Can multiple moral principles be valid and applicable depending on the situation?",
    answers = list(
      "Strongly Agree" = c("Moral Pluralism" = 5, "Moral Particularism" = 3),
      "Agree" = c("Moral Pluralism" = 3, "Moral Particularism" = 2),
      "Neutral" = c(),
      "Disagree" = c(),
      "Strongly Disagree" = c()
    ),
    followup = list(
      question = "Do you believe that no single moral theory can address all ethical dilemmas?",
      answers = list(
        "Strongly Agree" = c("Moral Pluralism" = 5),
        "Agree" = c("Moral Pluralism" = 3),
        "Neutral" = c(),
        "Disagree" = c(),
        "Strongly Disagree" = c()
      )
    )
  ),
  
  # Question 12: Contractualism
  list(
    question = "Is morality based on agreements or contracts made between rational individuals?",
    answers = list(
      "Strongly Agree" = c("Contractualism" = 5),
      "Agree" = c("Contractualism" = 3),
      "Neutral" = c(),
      "Disagree" = c(),
      "Strongly Disagree" = c("Ethical Egoism" = 1)
    ),
    followup = list(
      question = "Should moral rules be those that no one could reasonably reject?",
      answers = list(
        "Strongly Agree" = c("Contractualism" = 3),
        "Agree" = c("Contractualism" = 2),
        "Neutral" = c(),
        "Disagree" = c("Ethical Egoism" = 3),
        "Strongly Disagree" = c("Ethical Egoism" = 4)
      )
    )
  ),
  
  # Question 13: Postmodern Ethics
  list(
    question = "Are moral values subjective and shaped by power structures without overarching truths?",
    answers = list(
      "Strongly Agree" = c("Postmodern Ethics" = 5, "Constructivism" = 3),
      "Agree" = c("Postmodern Ethics" = 3, "Constructivism" = 2),
      "Neutral" = c(),
      "Disagree" = c("Moral Realism" = 3, "Moral Objectivism" = 2),
      "Strongly Disagree" = c("Moral Realism" = 5, "Moral Objectivism" = 4)
    ),
    followup = list(
      question = "Do you think that morality is fragmented and resists universal explanations?",
      answers = list(
        "Strongly Agree" = c("Postmodern Ethics" = 5),
        "Agree" = c("Postmodern Ethics" = 3),
        "Neutral" = c(),
        "Disagree" = c("Moral Objectivism" = 3, "Moral Realism" = 3),
        "Strongly Disagree" = c("Moral Objectivism" = 5, "Moral Realism" = 5)
      )
    )
  ),
  
  # Question 14: Postmodern Ethics (Continued)
  list(
    question = "Do you believe that universal moral truths are an illusion imposed by dominant cultures or power structures?",
    answers = list(
      "Strongly Agree" = c("Postmodern Ethics" = 5, "Constructivism" = 3),
      "Agree" = c("Postmodern Ethics" = 3, "Constructivism" = 2),
      "Neutral" = c(),
      "Disagree" = c("Moral Realism" = 3),
      "Strongly Disagree" = c("Moral Realism" = 5)
    ),
    followup = list(
      question = "Is it important to deconstruct traditional moral narratives to uncover hidden biases?",
      answers = list(
        "Strongly Agree" = c("Postmodern Ethics" = 5),
        "Agree" = c("Postmodern Ethics" = 3),
        "Neutral" = c(),
        "Disagree" = c(),
        "Strongly Disagree" = c()
      )
    )
  ),
  
  # Question 15: Moral Minimalism
  list(
    question = "Do moral obligations extend only to minimal duties, primarily to avoid harming others?",
    answers = list(
      "Strongly Agree" = c("Moral Minimalism" = 5, "Libertarianism" = 3),
      "Agree" = c("Moral Minimalism" = 3, "Libertarianism" = 2),
      "Neutral" = c(),
      "Disagree" = c("Altruism" = 3, "Deontology" = 2),
      "Strongly Disagree" = c("Altruism" = 5, "Deontology" = 4)
    ),
    followup = list(
      question = "Is it sufficient to fulfill minimal moral duties without engaging in additional moral actions?",
      answers = list(
        "Strongly Agree" = c("Moral Minimalism" = 5),
        "Agree" = c("Moral Minimalism" = 3),
        "Neutral" = c(),
        "Disagree" = c("Altruism" = 3, "Deontology" = 2),
        "Strongly Disagree" = c("Altruism" = 5, "Deontology" = 4)
      )
    )
  ),
  
  # Question 16: Existentialist Ethics
  list(
    question = "Do you believe that individual freedom and personal choice are central to moral decision-making?",
    answers = list(
      "Strongly Agree" = c("Existentialist Ethics" = 5, "Ethical Egoism" = 3),
      "Agree" = c("Existentialist Ethics" = 3, "Ethical Egoism" = 2),
      "Neutral" = c(),
      "Disagree" = c("Divine Command Theory" = 2),
      "Strongly Disagree" = c("Divine Command Theory" = 3)
    ),
    followup = list(
      question = "Do you believe that people must create their own values through authentic choices?",
      answers = list(
        "Strongly Agree" = c("Existentialist Ethics" = 5),
        "Agree" = c("Existentialist Ethics" = 3),
        "Neutral" = c(),
        "Disagree" = c("Divine Command Theory" = 3),
        "Strongly Disagree" = c("Divine Command Theory" = 4)
      )
    )
  ),
  
  # Question 17: Utilitarianism vs. Deontology
  list(
    question = "Do you believe that the best actions are those that lead to the greatest happiness for the most people?",
    answers = list(
      "Strongly Agree" = c("Act Utilitarianism" = 5, "Rule Utilitarianism" = 3, "Pragmatism" = 2),
      "Agree" = c("Act Utilitarianism" = 3, "Rule Utilitarianism" = 2, "Pragmatism" = 1),
      "Neutral" = c(),
      "Disagree" = c("Kantian Deontology" = 3, "Virtue Ethics" = 2),
      "Strongly Disagree" = c("Kantian Deontology" = 5, "Virtue Ethics" = 4)
    ),
    followup = list(
      question = "Should actions be judged solely by the amount of good they produce for the greatest number of people?",
      answers = list(
        "Strongly Agree" = c("Act Utilitarianism" = 5, "Rule Utilitarianism" = 3),
        "Agree" = c("Act Utilitarianism" = 3, "Rule Utilitarianism" = 2),
        "Neutral" = c(),
        "Disagree" = c("Kantian Deontology" = 3, "Virtue Ethics" = 2),
        "Strongly Disagree" = c("Kantian Deontology" = 5, "Virtue Ethics" = 4)
      )
    )
  ),
  
  # Question 18: Deontology vs. Utilitarianism
  list(
    question = "Certain actions are morally required, regardless of their outcomes.",
    answers = list(
      "Strongly Agree" = c("Kantian Deontology" = 5, "Rule Deontology" = 3),
      "Agree" = c("Kantian Deontology" = 3, "Rule Deontology" = 2),
      "Neutral" = c(),
      "Disagree" = c("Act Utilitarianism" = 3, "Moral Relativism" = 2),
      "Strongly Disagree" = c("Act Utilitarianism" = 5, "Moral Relativism" = 4)
    ),
    followup = list(
      question = "Do you believe that some duties must be performed even if they lead to negative consequences?",
      answers = list(
        "Strongly Agree" = c("Kantian Deontology" = 5, "Rule Deontology" = 3),
        "Agree" = c("Kantian Deontology" = 3, "Rule Deontology" = 2),
        "Neutral" = c(),
        "Disagree" = c("Act Utilitarianism" = 3),
        "Strongly Disagree" = c("Act Utilitarianism" = 5)
      )
    )
  ),
  
  # Question 19: Virtue Ethics
  list(
    question = "Developing good character traits is more important than following rules or assessing consequences.",
    answers = list(
      "Strongly Agree" = c("Classical Virtue Ethics" = 5, "Mixed Virtue Ethics" = 3),
      "Agree" = c("Classical Virtue Ethics" = 3, "Mixed Virtue Ethics" = 2),
      "Neutral" = c(),
      "Disagree" = c("Kantian Deontology" = 2, "Act Utilitarianism" = 2),
      "Strongly Disagree" = c("Kantian Deontology" = 3, "Act Utilitarianism" = 3)
    ),
    followup = list(
      question = "Is personal virtue the foundation of ethical behavior?",
      answers = list(
        "Strongly Agree" = c("Classical Virtue Ethics" = 5, "Mixed Virtue Ethics" = 3),
        "Agree" = c("Classical Virtue Ethics" = 3, "Mixed Virtue Ethics" = 2),
        "Neutral" = c(),
        "Disagree" = c("Deontology" = 2, "Utilitarianism" = 2),
        "Strongly Disagree" = c("Deontology" = 3, "Utilitarianism" = 3)
      )
    )
  ),
  
  # Question 20: Ethical Egoism vs. Altruism
  list(
    question = "If helping others doesn't benefit you personally, is it still important to do so?",
    answers = list(
      "Absolutely, it's important regardless of personal benefit." = c("Altruism" = 5, "Care Ethics" = 3),
      "Usually, but personal benefit can be a factor." = c("Altruism" = 3, "Care Ethics" = 2),
      "Not sure." = c(),
      "Not necessarily; personal benefit should be considered." = c( "Libertarianism" = 2),
      "No, personal benefit is the priority." = c("Ethical Egoism" = 5, "Libertarianism" = 4)
    ),
    followup = list(
      question = "Is pursuing one's own goals and happiness the primary moral duty?",
      answers = list(
        "Strongly Agree" = c("Ethical Egoism" = 5, "Libertarianism" = 3),
        "Agree" = c("Ethical Egoism" = 3, "Libertarianism" = 2),
        "Neutral" = c(),
        "Disagree" = c("Altruism" = 3, "Care Ethics" = 2),
        "Strongly Disagree" = c("Altruism" = 5, "Care Ethics" = 4)
      )
    )
  ),
  
  # Question 21: Hedonism
  list(
    question = "Do you consider pleasure to be the ultimate measure of what is morally right?",
    answers = list(
      "Strongly Agree" = c("Hedonism" = 5),
      "Agree" = c("Hedonism" = 3),
      "Neutral" = c(),
      "Disagree" = c("Virtue Ethics" = 3),
      "Strongly Disagree" = c("Virtue Ethics" = 5)
    ),
    followup = list(
      question = "Should actions be evaluated solely based on their ability to produce pleasure or reduce pain?",
      answers = list(
        "Strongly Agree" = c("Hedonism" = 5),
        "Agree" = c("Hedonism" = 3),
        "Neutral" = c(),
        "Disagree" = c("Virtue Ethics" = 3),
        "Strongly Disagree" = c("Virtue Ethics" = 5)
      )
    )
  ),
  
  # Question 22: Divine Command Theory
  list(
    question = "Do you think that moral guidelines should be based on religious teachings?",
    answers = list(
      "Strongly Agree" = c("Divine Command Theory" = 5),
      "Agree" = c("Divine Command Theory" = 3),
      "Neutral" = c(),
      "Disagree" = c("Moral Skepticism" = 2),
      "Strongly Disagree" = c("Moral Skepticism" = 4)
    ),
    followup = list(
      question = "Is adherence to religious commandments essential for moral behavior?",
      answers = list(
        "Strongly Agree" = c("Divine Command Theory" = 5),
        "Agree" = c("Divine Command Theory" = 3),
        "Neutral" = c(),
        "Disagree" = c("Moral Skepticism" = 2),
        "Strongly Disagree" = c("Moral Skepticism" = 4)
      )
    )
  ),
  
  # Question 23: Feminist Ethics
  list(
    question = "Is addressing social inequalities, such as gender or race, crucial in making moral decisions?",
    answers = list(
      "Strongly Agree" = c("Feminist/Gender Theory Ethics" = 5, "Care Ethics" = 3),
      "Agree" = c("Feminist/Gender Theory Ethics" = 3, "Care Ethics" = 2),
      "Neutral" = c(),
      "Disagree" = c("Libertarianism" = 3),
      "Strongly Disagree" = c("Libertarianism" = 5)
    ),
    followup = list(
      question = "Do you believe that addressing gender inequality is essential to achieving moral progress?",
      answers = list(
        "Strongly Agree" = c("Feminist/Gender Theory Ethics" = 5, "Care Ethics" = 3),
        "Agree" = c("Feminist/Gender Theory Ethics" = 3, "Care Ethics" = 2),
        "Neutral" = c(),
        "Disagree" = c("Libertarianism" = 3),
        "Strongly Disagree" = c("Libertarianism" = 5)
      )
    )
  ),
  
  # Question 24: Environmental Ethics
  list(
    question = "We have moral obligations to protect the environment and non-human life.",
    answers = list(
      "Strongly Agree" = c("Environmental Ethics" = 5, "Altruism" = 3),
      "Agree" = c("Environmental Ethics" = 3, "Altruism" = 2),
      "Neutral" = c(),
      "Disagree" = c("Ethical Egoism" = 3, "Libertarianism" = 2),
      "Strongly Disagree" = c("Ethical Egoism" = 5, "Libertarianism" = 4)
    ),
    followup = list(
      question = "Should the intrinsic value of nature guide our moral decisions?",
      answers = list(
        "Strongly Agree" = c("Environmental Ethics" = 5, "Altruism" = 3),
        "Agree" = c("Environmental Ethics" = 3, "Altruism" = 2),
        "Neutral" = c(),
        "Disagree" = c("Ethical Egoism" = 3, "Libertarianism" = 2),
        "Strongly Disagree" = c("Ethical Egoism" = 5, "Libertarianism" = 4)
      )
    )
  ),
  
  # Question 25: Emotivism and Care Ethics
  list(
    question = "Emotional responses are a valid basis for moral decisions.",
    answers = list(
      "Strongly Agree" = c("Emotivism" = 5, "Care Ethics" = 3),
      "Agree" = c("Emotivism" = 3, "Care Ethics" = 2),
      "Neutral" = c(),
      "Disagree" = c("Kantian Deontology" = 3, "Virtue Ethics" = 2),
      "Strongly Disagree" = c("Kantian Deontology" = 5, "Virtue Ethics" = 4)
    ),
    followup = list(
      question = "Do you believe that empathy and feelings should guide ethical choices?",
      answers = list(
        "Strongly Agree" = c("Emotivism" = 5, "Care Ethics" = 3),
        "Agree" = c("Emotivism" = 3, "Care Ethics" = 2),
        "Neutral" = c(),
        "Disagree" = c("Kantian Deontology" = 3, "Virtue Ethics" = 2),
        "Strongly Disagree" = c("Kantian Deontology" = 5, "Virtue Ethics" = 4)
      )
    )
  ),
  
  # Question 26: Deontology vs. Pragmatism
  list(
    question = "Is following moral rules or duties more important than focusing on the outcomes of actions?",
    answers = list(
      "Strongly Agree" = c("Deontology" = 5, "Kantian Deontology" = 4),
      "Agree" = c("Deontology" = 3, "Kantian Deontology" = 2),
      "Neutral" = c(),
      "Disagree" = c("Utilitarianism" = 3, "Pragmatism" = 2),
      "Strongly Disagree" = c("Utilitarianism" = 5, "Pragmatism" = 4)
    ),
    followup = list(
      question = "Should moral duties be upheld even if they lead to less favorable consequences?",
      answers = list(
        "Strongly Agree" = c("Deontology" = 5),
        "Agree" = c("Deontology" = 3),
        "Neutral" = c(),
        "Disagree" = c("Utilitarianism" = 3),
        "Strongly Disagree" = c("Utilitarianism" = 5)
      )
    )
  ),
  
  # Question 27: Justice vs. Compassion
  list(
    question = "Justice should be prioritised over compassion in moral decision-making.",
    answers = list(
      "Strongly Agree" = c("Deontology" = 5, "Libertarianism" = 3),
      "Agree" = c("Deontology" = 3, "Libertarianism" = 2),
      "Neutral" = c(),
      "Disagree" = c("Care Ethics" = 3, "Altruism" = 2),
      "Strongly Disagree" = c("Care Ethics" = 5, "Altruism" = 4)
    ),
    followup = list(
      question = "Is upholding justice more important than showing mercy in ethical dilemmas?",
      answers = list(
        "Strongly Agree" = c("Deontology" = 5, "Libertarianism" = 3),
        "Agree" = c("Deontology" = 3, "Libertarianism" = 2),
        "Neutral" = c(),
        "Disagree" = c("Care Ethics" = 3, "Altruism" = 2),
        "Strongly Disagree" = c("Care Ethics" = 5, "Altruism" = 4)
      )
    )
  ),
  
  # Question 28: Moral Skepticism vs. Pragmatism
  list(
    question = "Does moral skepticism lead to the conclusion that we should refrain from making moral judgments?",
    answers = list(
      "Strongly Agree" = c("Moral Skepticism" = 5, "Moral Nihilism" = 3),
      "Agree" = c("Moral Skepticism" = 3, "Moral Nihilism" = 2),
      "Neutral" = c(),
      "Disagree" = c("Pragmatism" = 3, "Constructivism" = 2),
      "Strongly Disagree" = c("Pragmatism" = 5, "Constructivism" = 4)
    ),
    followup = list(
      question = "Should moral uncertainty discourage us from acting on moral considerations?",
      answers = list(
        "Strongly Agree" = c("Moral Skepticism" = 5),
        "Agree" = c("Moral Skepticism" = 3),
        "Neutral" = c(),
        "Disagree" = c("Pragmatism" = 3),
        "Strongly Disagree" = c("Pragmatism" = 5)
      )
    )
  )
)

total_questions <- length(questions)

# The rest of your code remains the same...

# UI definition
ui <- fluidPage(
  theme = shinytheme("cerulean"),
  useShinyjs(),
  
  # Meta viewport for mobile responsiveness
  tags$head(
    tags$meta(name = "viewport", content = "width=device-width, initial-scale=1")
  ),
  
  titlePanel("Moral Philosophy Quiz"),
  
  # Responsive layout
  fluidRow(
    column(
      width = 12,
      uiOutput("progress"),
      h4(textOutput("questionText")),
      uiOutput("answerUI"),
      actionButton("nextBtn", "Next Question", class = "btn-primary")
    )
  ),
  
  hr(),
  
  # Placeholder for results, hidden until quiz completion
  uiOutput("resultsUI")
)

# Server logic
server <- function(input, output, session) {
  # Initialize reactive values for scores
  metaethical_scores <- reactiveValues()
  for (position in metaethical_positions) {
    metaethical_scores[[position]] <- 0
  }
  
  normative_scores <- reactiveValues()
  for (philosophy in normative_philosophies) {
    normative_scores[[philosophy]] <- 0
  }
  
  current_question <- reactiveVal(1)  # Current question index
  in_followup <- reactiveVal(FALSE)   # Flag for whether we are in a follow-up question
  
  output$progress <- renderUI({
    progress <- round(((current_question() - 1) / total_questions) * 100)
    progressBar(id = "quizProgress", value = progress, display_pct = TRUE)
  })
  
  output$questionText <- renderText({
    question_idx <- current_question()
    if (question_idx > length(questions)) {
      return(NULL)
    }
    
    if (in_followup()) {
      question_text <- questions[[question_idx]]$followup$question
    } else {
      question_text <- questions[[question_idx]]$question
    }
    question_text
  })
  
  output$answerUI <- renderUI({
    question_idx <- current_question()
    if (question_idx > length(questions)) {
      return(NULL)
    }
    
    question_data <- if (in_followup()) questions[[question_idx]]$followup else questions[[question_idx]]
    answers <- names(question_data$answers)
    
    if (length(answers) > 0) {
      radioButtons(
        "answer",
        "Choose your answer:",
        choices = answers,
        selected = character(0),
        width = "100%"
      )
    } else {
      return(NULL)
    }
  })
  
  update_scores <- function(answer_weights) {
    for (key in names(answer_weights)) {
      if (key %in% metaethical_positions) {
        metaethical_scores[[key]] <- metaethical_scores[[key]] + answer_weights[[key]]
      } else if (key %in% normative_philosophies) {
        normative_scores[[key]] <- normative_scores[[key]] + answer_weights[[key]]
      }
    }
  }
  
  remove_contradictions <- function(positions, contradictions) {
    positions_to_remove <- c()
    for (pos in positions) {
      conflicting_positions <- contradictions[[pos]]
      if (!is.null(conflicting_positions)) {
        for (conflict in conflicting_positions) {
          if (conflict %in% positions) {
            pos_score <- metaethical_scores[[pos]]
            conflict_score <- metaethical_scores[[conflict]]
            if (pos_score >= conflict_score) {
              positions_to_remove <- c(positions_to_remove, conflict)
            } else {
              positions_to_remove <- c(positions_to_remove, pos)
            }
          }
        }
      }
    }
    
    positions <- setdiff(positions, positions_to_remove)
    return(unique(positions))
  }
  
  calculate_results <- function() {
    # Metaethical positions
    meta_scores <- sapply(metaethical_positions, function(pos) metaethical_scores[[pos]])
    top_meta_score <- max(meta_scores)
    top_meta_positions <- metaethical_positions[meta_scores == top_meta_score]
    
    # Remove contradictory positions
    final_meta_positions <- remove_contradictions(top_meta_positions, contradictions)
    
    # Normative philosophies
    norm_scores <- sapply(normative_philosophies, function(phil) normative_scores[[phil]])
    top_norm_score <- max(norm_scores)
    top_norm_philosophies <- normative_philosophies[norm_scores == top_norm_score]
    
    # Check for contradictions
    contradictions_count <- 0
    contradiction_list <- list()  # To store detailed contradictions
    
    for (pos in final_meta_positions) {
      conflicting_positions <- contradictions[[pos]]
      if (!is.null(conflicting_positions)) {
        # Check if any conflicting positions are also in final_meta_positions
        conflicts_in_top <- intersect(conflicting_positions, final_meta_positions)
        if (length(conflicts_in_top) > 0) {
          contradiction_list[[pos]] <- conflicts_in_top
          contradictions_count <- contradictions_count + 1
        }
      }
    }
    
    # Return results
    list(
      metaethical = final_meta_positions,
      normative = top_norm_philosophies,
      meta_scores = meta_scores,
      norm_scores = norm_scores,
      contradictions_count = contradictions_count,
      contradiction_list = contradiction_list
    )
  }
  
  # Handle the next button click
  observeEvent(input$nextBtn, {
    question_idx <- current_question()
    selected_answer <- input$answer
    
    # Check if an answer is selected
    if (is.null(selected_answer) || selected_answer == "") {
      showModal(modalDialog(
        title = "No Answer Selected",
        "Please select an answer before proceeding.",
        easyClose = TRUE,
        footer = NULL
      ))
      return()
    }
    
    # Determine whether we are in a follow-up question
    question_data <- if (in_followup()) questions[[question_idx]]$followup else questions[[question_idx]]
    
    # Get the answer weights for the selected answer
    if (selected_answer %in% names(question_data$answers)) {
      answer_weights <- question_data$answers[[selected_answer]]
      update_scores(answer_weights)
    }
    
    # Handle follow-up or next question
    if (selected_answer == "Neutral" && !in_followup() && !is.null(questions[[question_idx]]$followup)) {
      in_followup(TRUE)  # Ask follow-up question
    } else {
      if (in_followup()) {
        in_followup(FALSE)
        current_question(question_idx + 1)
      } else {
        current_question(question_idx + 1)
      }
    }
    
    # Check if we've reached the end of the quiz
    if (current_question() > length(questions)) {
      results <- calculate_results()
      
      # Display metaethical results
      output$resultMetaethical <- renderText({
        meta_positions <- results$metaethical
        if (length(meta_positions) == 0) {
          "No dominant metaethical position identified."
        } else {
          paste(meta_positions, collapse = ", ")
        }
      })
      
      # Display normative philosophy results
      output$resultNormative <- renderText({
        norm_philosophies <- results$normative
        if (length(norm_philosophies) == 0) {
          "No dominant normative ethical theory identified."
        } else {
          paste(norm_philosophies, collapse = ", ")
        }
      })
      
      # Prepare data for radar charts
      meta_scores_df <- data.frame(
        Subcategory = rep(names(metaethical_subcategories), times = sapply(metaethical_subcategories, length)),
        Position = unlist(metaethical_subcategories),
        Score = sapply(unlist(metaethical_subcategories), function(pos) results$meta_scores[pos])
      )
      meta_scores_summary <- meta_scores_df %>%
        group_by(Subcategory) %>%
        summarise(Score = sum(Score))
      
      norm_scores_df <- data.frame(
        Subcategory = rep(names(normative_subcategories), times = sapply(normative_subcategories, length)),
        Philosophy = unlist(normative_subcategories),
        Score = sapply(unlist(normative_subcategories), function(phil) results$norm_scores[phil])
      )
      norm_scores_summary <- norm_scores_df %>%
        group_by(Subcategory) %>%
        summarise(Score = sum(Score))
      
      # Normalize scores for radar chart (optional)
      meta_max_score <- max(meta_scores_summary$Score)
      meta_scores_summary$NormalizedScore <- meta_scores_summary$Score / meta_max_score
      
      norm_max_score <- max(norm_scores_summary$Score)
      norm_scores_summary$NormalizedScore <- norm_scores_summary$Score / norm_max_score
      
      # Set desired ordering for subcategories
      desired_meta_order <- c(
        "Moral Realism",
        "Moral Objectivism",
        "Cognitivism",
        "Non-Cognitivism",
        "Constructivism",
        "Postmodern Ethics",
        "Anti-Realism",
        "Moral Skepticism",
        "Particularism",
        "Existentialism"
      )
      meta_scores_summary$Subcategory <- factor(meta_scores_summary$Subcategory, levels = desired_meta_order)
      
      desired_norm_order <- c(
        "Utilitarianism",
        "Deontology",
        "Virtue Ethics",
        "Ethics of Care",
        "Gender Theory Ethics",
        "Egoism",
        "Libertarianism",
        "Altruism",
        "Religious Ethics",
        "Emotivism",
        "Pragmatism",
        "Hedonism",
        "Contractualism"
      )
      norm_scores_summary$Subcategory <- factor(norm_scores_summary$Subcategory, levels = desired_norm_order)
      
      # Metaethical Spider Chart
      output$metaethicalPlot <- renderPlotly({
        plot_ly(
          type = 'scatterpolar',
          r = meta_scores_summary$NormalizedScore,
          theta = meta_scores_summary$Subcategory,
          fill = 'toself',
          mode = 'lines'
        ) %>% layout(polar = list(
          radialaxis = list(
            visible = TRUE,
            range = c(0, 1)
          )),
          showlegend = FALSE,
          title = "Metaethical Subcategories Radar Chart"
        )
      })
  
  # Normative Spider Chart
  output$normativePlot <- renderPlotly({
    plot_ly(
      type = 'scatterpolar',
      r = norm_scores_summary$NormalizedScore,
      theta = norm_scores_summary$Subcategory,
      fill = 'toself',
      mode = 'lines'
    ) %>% layout(polar = list(
      radialaxis = list(
        visible = TRUE,
        range = c(0, 1)
      )),
      showlegend = FALSE,
      title = "Normative Ethical Subcategories Radar Chart"
    )
  })

# Display detailed metaethical scores
output$metaScoresTable <- renderTable({
  meta_scores_df[order(-meta_scores_df$Score), ]
})

# Display detailed normative scores
output$normScoresTable <- renderTable({
  norm_scores_df[order(-norm_scores_df$Score), ]
})

output$contradictionsText <- renderText({
  if (results$contradictions_count > 0) {
    paste("Your answers resulted in", results$contradictions_count, "contradictions. These contradictions occurred in: ",
          paste(names(results$contradiction_list), collapse = ", "),
          ". Please review these positions for consistency.")
  } else {
    "No contradictions detected in your responses."
  }
})

# Disable the next button to prevent further clicks
disable("nextBtn")

# Render the results UI
output$resultsUI <- renderUI({
  fluidRow(
    column(
      width = 12,
      h3("Your Results"),
      h4("Metaethical Position"),
      textOutput("resultMetaethical"),
      plotlyOutput("metaethicalPlot", height = "500px"),
      h5("Detailed Metaethical Scores"),
      tableOutput("metaScoresTable"),
      h4("Normative Ethical Theory"),
      textOutput("resultNormative"),
      plotlyOutput("normativePlot", height = "500px"),
      h5("Detailed Normative Scores"),
      tableOutput("normScoresTable"),
      h4("Contradictions in Your Responses"),
      textOutput("contradictionsText")
    )
  )
})
    }
  })
}

# Run the application
shinyApp(ui = ui, server = server)





rsconnect::setAccountInfo(name='nathanfoale', 
                          token=Sys.getenv("SHINYAPPS_TOKEN"), 
                          secret=Sys.getenv("SHINYAPPS_SECRET"))


 
rsconnect::deployApp()