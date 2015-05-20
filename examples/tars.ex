defmodule TARS do
  use Slacker
  use Slacker.Matcher

  match ~r/Sense of humor\. New level setting: ([0-9]+)%/, :set_humor
  match "Great idea. A massive, sarcastic robot.", [CueLight, :turn_on]

  def set_humor(tars, msg, level) do
    reply = "Sense of humor set to #{level}"
    say tars, msg["channel"], reply
  end
end
