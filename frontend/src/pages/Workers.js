import NavBar from '../components/NavBar';
import WorkerNotes from '../components/WorkerNotes';
import WorkerTimes from '../components/WorkerTimes';
import {useRef} from 'react';
import {useState} from 'react';
import classes from './Workers.module.css';
import Backdrop from '../components/Backdrop';

function Workers()
{
    const [backdropIsVisible, setBackdropVisiblity] = useState(false);
    const [notesAreVisible, setNoteVisibility] = useState(false);
    const [timesheetIsVisible, setTimesheetVisibility] = useState(false);
    const [errorMsg, setMsg] = useState("");
    const [filtered, setFiltered] = useState([]);
    const [activeName, setName] = useState("");
    const [notes, setNotes] = useState([]);
    const [times, setTimes] = useState([]);

    const searchTextRef = useRef();


    function closeAll()
    {
        setBackdropVisiblity(false);
        setNoteVisibility(false);
        setTimesheetVisibility(false);
    }

    function renderNotes()
    {
        setNoteVisibility(true);
        setBackdropVisiblity(true);
    }

    function loadTimesheet()
    {
        setTimesheetVisibility(true);
        setBackdropVisiblity(true);
    }

    async function loadNotes(email, name)
    {
        var email = email;

        const Data =
        {
            "email": email
        };

        var js = JSON.stringify(Data);
        try{
            const response = await fetch('https://cop4331group2.herokuapp.com/api/searchIndividualNotes', 
            {method: 'POST', body:js, headers:{'Content-Type': 'application/json'}});
            var res = JSON.parse(await response.text());
            
            if(res.error == 'Success')
            {
                setNotes(res.notes);
            }else{
                setNotes([]);
            }

        }catch(e){
            alert(e.toString());
        }

        setName(name);
        renderNotes();
    }

    async function loadTimes(email, name)
    {
        var email = email;

        const Data =
        {
            "email": email
        };

        var js = JSON.stringify(Data);
        try{
            const response = await fetch('https://cop4331group2.herokuapp.com/api/searchIndividualTimesheet', 
            {method: 'POST', body:js, headers:{'Content-Type': 'application/json'}});
            var res = JSON.parse(await response.text());
            
            if(res.error == 'Success')
            {
                setTimes(res.times);
            }else{
                setTimes([]);
            }

        }catch(e){
            alert(e.toString());
        }

        loadTimesheet();
    }

    async function searchHandler(event)
    {
        event.preventDefault();
        var user = JSON.parse(localStorage.getItem('user_data'));

        var search = searchTextRef.current.value;
        var code = user.CompanyCode;

        const Data =
        {
            input: search,
            companyCode: code,
        };

        var js = JSON.stringify(Data);
        try{
            const response = await fetch('https://cop4331group2.herokuapp.com/api/searchWorkers', 
            {method: 'POST', body:js, headers:{'Content-Type': 'application/json'}});
            var res = JSON.parse(await response.text());
            setMsg(res.error);

        }catch(e){
            alert(e.toString());
        }

        if(res.error == '')
        {
            localStorage.setItem('workers', JSON.stringify(res.workers));
            
            var arr = JSON.parse(localStorage.getItem('workers'));
            var filt = arr.filter(function (el) {
                return el != null;
            });

            rerender(filt);
        }
    }

    function rerender(arr)
    {
        setFiltered(arr);
    }

    return (
        <div className={classes.back}>
            <NavBar></NavBar>
            <div className={classes.card}>
                <div className={classes.cardheading}>
                    <h2 className={classes.h2}>Workers</h2>
                </div>
                <div>
                    <form onSubmit={searchHandler}>
                        <div className={classes.center}>
                            <input type='text' className={classes.search} placeholder='Name, email, phone, etc.' id='searchText' ref={searchTextRef}/>
                            <button className={classes.button}>Search</button>
                        </div>
                        {errorMsg && (<p className={classes.error}>{errorMsg}</p>)}
                    </form>
                </div>
                <div>
                    <table className={classes.table}>
                        <tr>
                            <th className={classes.first}>Name</th>
                            <th className={classes.second}>Email</th>
                            <th className={classes.third}>Phone</th>
                            <th className={classes.fourth}></th>
                        </tr>
                        {filtered.map(worker => 
                            <tr>
                                <td className={classes.first2}>{worker.firstName} {worker.lastName}</td>
                                <td className={classes.second2}>{worker.Email}</td>
                                <td className={classes.third2}>{worker.phone}</td>
                                <td className={classes.fourth2}>
                                    <button className={classes.button} onClick={()=> loadNotes(worker.Email, worker.firstName)}>Notes</button>
                                    <button className={classes.button} onClick={()=> loadTimes(worker.Email, worker.firstName)}>Timesheet</button>
                                </td>
                            </tr>
                        )}
                    </table>
                </div>
                <div>
                    {backdropIsVisible && <Backdrop onClick={closeAll}></Backdrop>}
                    {notesAreVisible && <WorkerNotes input={notes} name = {activeName} onClick={closeAll}></WorkerNotes>}
                    {timesheetIsVisible && <WorkerTimes input={times} name = {activeName} onClick={closeAll}></WorkerTimes>}
                </div>
            </div>
        </div>
    );
}

export default Workers;