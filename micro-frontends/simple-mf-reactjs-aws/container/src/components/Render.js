import { mount } from 'home/HomeApp';

import React, {useEffect, useRef} from 'react';
import { useHistory } from 'react-router-dom';

export default () => {
    const ref = useRef(null);
    const history = useHistory();

    useEffect(() => {
        const { onNavigation } = mount(ref.current, { 
            initialPath: history.location.pathname,

            onNavigate: ( {pathname: nextPathname} ) => {
                console.log('App -> Container (onNavigation)', nextPathname);
                const { pathname } = history.location;

                if (pathname !== nextPathname) {
                    history.push(nextPathname)
                }
        }});

        history.listen(onNavigation)
    }, []);

    return <div ref={ref}></div>
}