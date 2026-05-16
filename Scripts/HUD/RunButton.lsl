default
{
    touch_start(integer total_number)
    {
        llMessageLinked(LINK_SET, 0, "CHECK_AND_RUN", NULL_KEY);
    }
}