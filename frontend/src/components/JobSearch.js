import classes from './JobSearch.module.css';
import {useRef} from 'react';
import {useState} from 'react';

function JobSearch(props)
{
    const searchTextRef = useRef();
    const startDateRef = useRef();
    const endDateRef = useRef();
    const showMineRef = useRef();
    const showCompleteRef = useRef();
    const [showCompChecked, setCompChecked] = useState(false);
    const [showMineChecked, setMineChecked] = useState(false);

    function toggleMine()
    {
        setMineChecked(!showMineChecked);
    }

    function toggleComp()
    {
        setCompChecked(!showCompChecked);
    }

    async function searchHandler(event)
    {
        event.preventDefault();
        
    }

    return (
        <div className={classes.jobcard}>
            <div className={classes.cardheading}>
                <h3 className={classes.h3}>Search for Jobs</h3>
            </div>
            <div>
                <form onSubmit={searchHandler}>
                    <div>
                        <input type='text' className={classes.search} placeholder='Title, address, client, etc.' id='searchText' ref={searchTextRef}/>
                        <button className={classes.button}>Search</button>
                    </div>
                    <div>
                        <span className={classes.span}>Date range: </span>
                        <input type='date' className={classes.date} id='password' ref={startDateRef}/>
                        <span className={classes.span}> to </span>
                        <input type='date' className={classes.date} id='password' ref={endDateRef}/>
                    </div>
                    <div>
                        {props.utype == 'w' && <input type='checkbox' className={classes.check} id='showMine' onClick={toggleMine}></input>}
                        {props.utype == 'w' && <span className={classes.span2}> Only show jobs I'm signed up for</span>}
                    </div>
                    <div>
                        <input type='checkbox' className={classes.check} id='showComplete' onClick={toggleComp}></input>
                        <span className={classes.span2}> Include completed jobs</span>
                    </div>
                </form>
            </div>
        </div>
    );
}

export default JobSearch;