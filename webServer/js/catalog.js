/**
 * Created by bijiabo on 15/2/10.
 */
var catalog = "CHAPTER ONE Childhood: Abandoned and Chosen \
CHAPTER TWO Odd Couple: The Two Steves \
CHAPTER THREE The Dropout: Turn On, Tune In \
CHAPTER FOUR Atari and India: Zen and the Art of GameDesign \
CHAPTER FIVE The Apple I: Turn On, Boot Up, Jack In \
CHAPTER SIX The Apple II: Dawn ofaNewAge \
CHAPTER SEVEN Chrisann and Lisa: He Who Is Abandoned \
CHAPTER EIGHT Xerox and Lisa: Graphical User Interfaces \
CHAPTER NINE Going Public: A Man of Wealth and Fame \
CHAPTER TEN The Mac Is Born: You Say You Want aRevolution \
CHAPTER ELEVEN The Reality Distortion Field: Playing by His Own Setof Rules\
CHAPTER TWELVE The Design: RealArtists Simplify\
CHAPTER THIRTEEN Building the Mac: The Journey Is theReward\
CHAPTER FOURTEEN Enter ScuUey: The Pepsi Challenge\
CHAPTER FIFTEEN The Launch: A Dent in the Universe\
CHAPTER SIXTEEN Gates and Jobs: When Orbits Intersect\
CHAPTER SEVENTEEN Icarus: What Goes Up...\
    CHAPTER EIGHTEEN NEXT: Prometheus Unbound\
CHAPTER NINETEEN Pixar: Technology Meets Art\
CHAPTER TWENTY A Regular Guy: Love Is Just a Four-LetterWord\
CHAPTER TWENTY-ONE Family Man: At Home with the JobsClan\
CHAPTER TWENTY-TWO Toy Story: Buzz and Woody to theRescue\
CHAPTER TWENTY-THREE The Second Coming:What Rough Beast, Its HourCome Round at Last...\
    CHAPTER TWENTY-FOUR The Restoration: The Loser Now Will Be Later toWin\
CHAPTER TWENTY-FIVE Think Different:Jobs as iCEO\
CHAPTER TWENTY-SIX Design Principles: The Studio of Jobs andIve\
CHAPTER TWENTY-SEVEN The iMac: Hello (Again)\
CHAPTER TWENTY-EIGHT CEO: Still Crazy after All TheseYears\
CHAPTER TWENTY-NINE Apple Stores: Genius Bars and SienaSandstone\
CHAPTER THIRTY The Digital Hub: From iTunes to the iPod\
CHAPTER THIRTY-ONE The iTunes Store: I'm the Pied Piper \
CHAPTER THIRTY-TWO Music Man: The Sound Track of HisLife\
CHAPTER THIRTY-THREE Pixar's Friends: . . . and Foes \
CHAPTER THIRTY-FOUR Twenty-first-century Macs: Setting AppleApart\
CHAPTER THIRTY-FIVE Round One: Memento Mori\
CHAPTER THIRTY-SIXThe iPhone: Three Revolutionary Products inOne\
CHAPTER THIRTY-SEVEN Round Two: The Cancer Recurs\
CHAPTER THIRTY-EIGHT The iPad: Into the Post-PC Era\
CHAPTER THIRTY-NINE New Battles: And Echoes of Old Ones\
CHAPTER FORTY To Infinity: The Cloud, the Spaceship, andBeyond\
CHAPTER FORTY-ONE Round Three: The Twilight Struggle\
CHAPTER FORTY-TWO Legacy: The Brightest Heaven ofInvention ";

var catalogArray = catalog.split("CHAPTER ");
console.log(catalogArray);

var catalogArrayNew = [];
var indexCache = 0;
for(var i= 0,len=catalogArray.length;i<len;i++)
{
    if(!/^\t*$/.test(catalogArray[i]))
    {
        console.log(catalogArray[i]);
        catalogArrayNew.push(
            {
                id : indexCache,
                title : catalogArray[i].replace(/^\t*[a-zA-Z]+ /ig,"")
            }
        );
        indexCache++;
    }
}
console.log(catalogArrayNew);
copy(catalogArrayNew);