load('render.star', 'render')
load('time.star', 'time')

words = {
    1: 'one',
    2: 'two',
    3: 'three',
    4: 'four',
    5: 'five',
    6: 'six',
    7: 'seven',
    8: 'eight',
    9: 'nine',
    10: 'ten',
    11: 'eleven',
    12: 'twelve',
    15: 'quarter',
    20: 'twenty',
    25: 'twenty-five',
    30: 'half',
}

def round(minutes):
    """Returns:
        minutes: rounded to the nearest 5.
        up: if we rounded up or down.
    """
    rounded = (minutes + 2) % 60 // 5 * 5
    up = False

    if rounded > 30:
        rounded = 60 - rounded
        up = True
    elif minutes > 30 and rounded == 0:
        up = True

    return rounded, up

def fuzzy_time(hours, minutes):
    glue = 'past'
    rounded, up = round(minutes)

    if up:
        hours += 1
        glue = 'til'

    if hours > 12:
        hours -= 12

    if rounded == 0:
        return [words[hours], "o'clock"]
    else:
        return [words[rounded], glue, words[hours]]

def main(config):
    timezone = config.get("timezone") or 'UTC'
    now = time.now().in_location(timezone)

    fuzzed = fuzzy_time(now.hour(), now.minute())
    # Add some left padding for ~style~.
    texts = [render.Text(' ' * i + s) for i, s in enumerate(fuzzed)]

    return render.Root(
            child = render.Padding(
                pad = 4,
                child = render.Column(
                    children = texts
                )
            )
    )
