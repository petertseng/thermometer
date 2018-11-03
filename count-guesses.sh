for i in janko/*; do
  if [ $i = "janko/fetch.rb" ]; then
    continue
  fi

  guesses=$(./thermometer $i | grep 'cause contradictions' | wc -l)
  if [ ! $guesses = "0" ]; then
    echo "$i: $guesses"
  fi
done
