import classes from './JobSearch.module.css';
import {useRef} from 'react';
import {useState} from 'react';

function JobSearch(props)
{
    const searchTextRef = useRef();
    const startDateRef = useRef();
    const endDateRef = useRef();
    const [showCompChecked, setCompChecked] = useState(false);
    const [showMineChecked, setMineChecked] = useState(false);

    const [errorMsg, setMsg] = useState("");

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
        var user = JSON.parse(localStorage.getItem('user_data'));

        var search = searchTextRef.current.value;
        var start = startDateRef.current.value;
        var end = endDateRef.current.value;
        var showMine = showMineChecked;
        var showComp = showCompChecked;
        var code = user.CompanyCode;
        var email = user.Email;

        const Data =
        {
            email: email,
            input: search,
            companyCode: code,
            showMine: showMine,
            showCompleted: showComp,
            start: start,
            end: end
        };

        var js = JSON.stringify(Data);
        try{
            const response = await fetch('https://cop4331group2.herokuapp.com/api/searchJobs', 
            {method: 'POST', body:js, headers:{'Content-Type': 'application/json'}});
            var res = JSON.parse(await response.text());
            setMsg(res.error);

        }catch(e){
            alert(e.toString());
        }

        if(res.error == '')
            localStorage.setItem('jobs', JSON.stringify(res.jobs));
        
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
                        {errorMsg && (<p className={classes.error}>{errorMsg}</p>)}
                    </div>
                </form>
            </div>
        </div>
    );
}

export default JobSearch;