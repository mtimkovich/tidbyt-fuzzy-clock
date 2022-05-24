load('render.star', 'render')
load('time.star', 'time')

words = {
    1: 'ONE',
    2: 'TWO',
    3: 'THREE',
    4: 'FOUR',
    5: 'FIVE',
    6: 'SIX',
    7: 'SEVEN',
    8: 'EIGHT',
    9: 'NINE',
    10: 'TEN',
    11: 'ELEVEN',
    12: 'TWELVE',
    15: 'QUARTER',
    20: 'TWENTY',
    25: 'TWENTY-FIVE',
    30: 'HALF',
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
    glue = 'PAST'
    rounded, up = round(minutes)

    if up:
        hours += 1
        glue = 'TIL'

    if hours > 12:
        hours -= 12

    if rounded == 0:
        return [words[hours], "O'CLOCK"]
    else:
        return [words[rounded], glue, words[hours]]

def main(config):
    timezone = config.get("tz") or 'UTC'
    now = time.now().in_location(timezone)

    fuzzed = fuzzy_time(now.hour, now.minute)
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
